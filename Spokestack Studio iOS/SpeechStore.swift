//
//  SpeechStore.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/13/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

class SpeechStore:  ObservableObject {
    @Published var isSpeaking: Bool
    @Published var isSynthesizing: Bool

    init() {
        self.isSpeaking = false;
        self.isSynthesizing = false;
    }
    
    lazy private var tts: TextToSpeech = {
        return TextToSpeech(self, configuration: SpeechConfiguration())
    }()
    
    func speak(_ text: String) {
        let input = TextToSpeechInput(text)
        isSynthesizing = true
        self.objectWillChange.send()
        tts.speak(input)
    }
    
}


extension SpeechStore: TextToSpeechDelegate {
    func didTrace(_ trace: String) {
         print("did trace \(trace)")
    }
    
    func success(result: TextToSpeechResult) {
        print("tts success")
    }
    
    func failure(error: Error) {
        print("tts failed \(error)")
        isSpeaking = false
        isSynthesizing = false
    }
    
    func didBeginSpeaking() {
        print("didBeginSpeaking")
        isSynthesizing = false
        isSpeaking = true
    }
    
    func didFinishSpeaking() {
        print("didFinishSpeaking")
        isSpeaking = false
    }
    
    
}
