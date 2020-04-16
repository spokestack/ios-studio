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
    
    @Published var isPipelineActive: Bool
    @Published var text: String
    
    init(text: String) {
        self.text = text
        self.isPipelineActive = false;
        self.pipeline.start()
    }
    
    lazy private var pipeline: SpeechPipeline = {
       
        return SpeechPipeline(self, pipelineDelegate: self)
    }()
    
}

extension PipelineStore: SpeechEventListener {
    func activate() {
        print("activated pipeline")
        self.pipeline.activate()
        text = ""
        isPipelineActive = true
    }

    func deactivate() {
        print("deactivated pipeline")
        self.pipeline.deactivate()
        DispatchQueue.main.async {
            self.isPipelineActive = false
        }
    }
    
    
    func didError(_ error: Error) {
        print("did didError \(error)")
    }
    
    func didTrace(_ trace: String) {
        print("did trace \(trace)")
    }
    
    func didRecognize(_ result: SpeechContext) {
        
        print("didRecognize \(result.isSpeech) and transscript \(result.transcript)")
        DispatchQueue.main.async {
            self.text = result.transcript
    
        }
    }

    func didTimeout() {
        print("didTimeout")
    }
    

}

extension PipelineStore: PipelineDelegate {
    func didInit() {
        print("didInit")
    }
    
    func didStart() {
        print("didStart")
    }
    
    func didStop() {
        print("didStop")
    }
    
    func setupFailed(_ error: String) {
        print("setup failed \(error)")
    }
    
}
