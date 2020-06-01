//
//  PipelineStore.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/13/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

class PipelineStore: ObservableObject {
    
    @Published var isListening: Bool
    
    @Published var text: String
    
    enum PipelineMode {
        case push2talk
        case wakeword
    }
    
    private var mode: PipelineMode = .push2talk
    
    lazy private var pipeline: SpeechPipeline = {
        return SpeechPipeline(self, pipelineDelegate: self)
    }()
    
    init(_ text: String) {
        
        self.text = text
        self.isListening = false
    }
    
    func startPipeline() {
        print("[\(mode)] starting pipeline")
        self.pipeline.start()
    }
    
    func configure(_ mode: PipelineMode) {
        print("configured mode \(mode)")
        self.mode = mode
        DispatchQueue.main.async {
            self.text = ""
        }
    }

    func stopPipeline() {
        print("[\(mode)] stopping pipeline")
        self.pipeline.stop()
    }
    
    func activatePipeline() {
        print("[\(mode)] manually activating pipeline")
        self.pipeline.activate()
        DispatchQueue.main.async {
            self.text = ""
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
}

extension PipelineStore: SpeechEventListener {
    
    func didActivate() {
        print("[\(mode)] heard wakeword")
        if mode == .wakeword {
            self.pipeline.activate()
            DispatchQueue.main.async {
                self.isListening = true
            }
        }
    }
    
    func didDeactivate() {
        print("[\(mode)] heard speech ended")
        
        /// this gets called after the user stops talking
        /// we need to actually deactive the pipeline next
        
        self.pipeline.deactivate()
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
    
    func failure(speechError: Error) {
        print("[\(mode)] did speechError \(speechError)")
    }
    
    func didTrace(_ trace: String) {
        print("[\(mode)] did trace \(trace)")
    }
    
    func didRecognize(_ result: SpeechContext) {
        
        print("[\(mode)] didRecognize \(result.isSpeech) and transscript \(result.transcript)")
        DispatchQueue.main.async {
            self.text = result.transcript
        }
    }

    func didTimeout() {
        print("[\(mode)] didTimeout")
    }
}

extension PipelineStore: PipelineDelegate {
    
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
