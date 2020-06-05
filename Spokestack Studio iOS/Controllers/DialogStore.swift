//
//  DialogStore.swift
//  Spokestack Studio iOS
//
//  Created by Cory D. Wiles on 6/2/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

class DialogStore: ObservableObject {
    
    @Published var isListening: Bool = false
    
    @Published var isSpeaking: Bool = false
    
    @Published var userSays: String?
    
    @Published var appSays: String?
    
    @ObservedObject private (set) var nluStore: NLUStore = NLUStore(nil)
    
    lazy private var dialogManager: SkillDialogController = {
        return SkillDialogController()
    }()
    
    private var currentResponse: HandlerOutput = HandlerOutput(speak: "")
    
    lazy private var tts: TextToSpeech = {
        return TextToSpeech(self, configuration: SpeechConfiguration())
    }()
    
    
    init() {}
    
    enum PipelineMode {
        case push2talk
        case wakeword
    }
    
    private var mode:PipelineMode = .push2talk
    
    lazy private var pipeline: SpeechPipeline = {
        return SpeechPipeline(self, pipelineDelegate: self)
    }()
    
    func startPipeline() {
        print("[\(mode)] starting pipeline")
        self.pipeline.start()
    }

    func stopPipeline() {
        print("[\(mode)] stopping pipeline")
        self.pipeline.stop()
    }
    
    func activatePipeline() {
        print("[\(mode)] manually activating pipeline")
        self.pipeline.activate()
        DispatchQueue.main.async {
            self.isListening = true
        }
        
    }
    
    func deactivatePipeline() {
        print("[\(mode)] manually deactivating pipeline")
        self.pipeline.deactivate()
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
    
    func speak(_ request:HandlerOutput) {
        DispatchQueue.main.async {
            self.appSays = request.speak
        self.isSpeaking = true
        }
        self.currentResponse = request
        self.tts.speak(TextToSpeechInput(request.speak))
    }
    
}

extension DialogStore: SpeechEventListener {
    func didActivate() {
        print("[\(mode)] heard wakeword")
        if (mode == .wakeword) {
            self.pipeline.activate()
            DispatchQueue.main.async {
                self.isListening = true
            }
        }
    }
    
    func didDeactivate() {
                print("[\(mode)] heard speech ended")
        //this gets called after the user stops talking
        //we need to actually deactive the pipeline next
        self.pipeline.deactivate()
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
    
    func failure(speechError: Error) {
        print("[\(mode)] did didError \(speechError)")
        currentResponse = try! self.dialogManager.turn("UnknownRequest", error: speechError)
        print(speak)
        self.appSays = currentResponse.speak
        self.isSpeaking = true
        self.tts.speak(TextToSpeechInput(currentResponse.speak))
    }
    
    func didError(_ error: Error) {
        print("[\(mode)] did didError \(error)")
        currentResponse = try! self.dialogManager.turn("UnknownRequest", error: error)
        print(speak)
        self.appSays = currentResponse.speak
        self.isSpeaking = true
        self.tts.speak(TextToSpeechInput(currentResponse.speak))
    }
    
    func didTrace(_ trace: String) {
        print("[\(mode)] did trace \(trace)")
    }
    
    func didRecognize(_ result: SpeechContext) {
        
        print("[\(mode)] didRecognize \(result.isSpeech) and transscript \(result.transcript)")
        DispatchQueue.main.async {
            self.appSays = nil;
            self.userSays = result.transcript
        }
        
        self.nluStore.classify([result.transcript], callback: {results in
            
            let _ = results.map({ result in
                print("nlu result")
                print(result)
                self.currentResponse = try! self.dialogManager.turn("IntentRequest", nluResult: result)
                print(self.currentResponse.speak)
                DispatchQueue.main.async {
                self.appSays = self.currentResponse.speak
                self.isSpeaking = true
                }
                self.tts.speak(TextToSpeechInput(self.currentResponse.speak))
            })
        })

//        let _ = nluService.nlu!.classify(utterances: [result.transcript])
//        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//        .sink(receiveCompletion: { completion in
//            switch completion {
//            case .failure(let error):
//                // respond appropriately to an error in classification
//                print("nlu failure \(error)")
//                break
//            case .finished:
//                // respond appropriately to finished classification
//                print("nlu finished")
//                break
//            }
//        }, receiveValue: { results in
//            let _ = results.map({ result in
//                print("nlu result")
//                print(result)
//                self.currentResponse = try! self.dialogManager.turn(type: "IntentRequest", nluResult: result)
//                print(self.currentResponse.speak)
//                DispatchQueue.main.async {
//                self.appSays = self.currentResponse.speak
//                self.isSpeaking = true
//                }
//                    self.tts.speak(TextToSpeechInput(self.currentResponse.speak))
//
//            })
//        })
    }

    func didTimeout() {
        print("[\(mode)] didTimeout")
        currentResponse = try! self.dialogManager.turn("TimeoutRequest")
        print(currentResponse.speak)
        DispatchQueue.main.async {
            self.userSays = nil
            self.appSays = self.currentResponse.speak
        self.isSpeaking = true
        }
            self.tts.speak(TextToSpeechInput(currentResponse.speak))
    }
    

}

extension DialogStore: PipelineDelegate {
    func didInit() {
        print("[\(mode)] didInit")
    }
    
    func didStart() {
        print("[\(mode)] didStart")
    }
    
    func didStop() {
        print("[\(mode)] didStop")
    }
    
    func setupFailed(_ error: String) {
        print("[\(mode)] setup failed \(error)")
    }
    
}


extension DialogStore: TextToSpeechDelegate {
    
    func success(result: TextToSpeechResult) {
        print("tts success")
    }
    
    func failure(ttsError error: Error) {
        print("tts failed \(error)")
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func didBeginSpeaking() {
        print("didBeginSpeaking")
//        DispatchQueue.main.async {
//            self.isSynthesizing = false
//            self.isSpeaking = true
//        }
    }
    
    func didFinishSpeaking() {
        print("didFinishSpeaking")
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
        
        if (currentResponse.reprompt != nil) {
            print("opening mic")
            activatePipeline();
        }
    }
    
    
}

