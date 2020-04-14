//
//  TTSDemoDetail.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/13/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct TTSDemoDetail: View {
    @ObservedObject var asrStore:PipelineStore
    @ObservedObject var ttsStore:SpeechStore
    
    
    
    var body: some View {
        ZStack {
            Color("SpokestackBackground").edgesIgnoringSafeArea(.all)
            VStack {
                
                Spacer()
                Text(asrStore.text).foregroundColor(Color("SpokestackPrimary")).padding()
                (ttsStore.isSynthesizing ? Text("Synthesizing...") : Text("")).padding().transition(
                    AnyTransition.opacity.animation(Animation.linear(duration: 1))
                )
                Spacer()
                
                hintView().transition(
                    AnyTransition.opacity.animation(Animation.linear(duration: 1))
                ).offset(x: 0, y: 60)
               
                recordingView()
                    .transition(
                        AnyTransition.opacity.animation(Animation.linear(duration: 1))
                )
            }.onReceive(asrStore.$text, perform: { text in
                if (text.count > 0) {
                    self.ttsStore.speak(text)
                }
            })
        }
    }
    
    func recordingView() -> some View {
        print("is speaking \(ttsStore.isSpeaking)")
        return Group {
            if (asrStore.isPipelineActive || ttsStore.isSpeaking) {
                WaveView().frame(height: 100.0)
            } else {
                Spacer().frame(height: 108.0)
            }
        }
    }
    
    func hintView() -> some View {
        return VStack {
            Group {
                if (ttsStore.isSpeaking || ttsStore.isSynthesizing) {
                    
                } else if (asrStore.isPipelineActive) {
                    MicButtonView(store:asrStore)
                } else {
                    Text("Tap the button below & speak")
                    Image("DownArrow")
                    MicButtonView(store:asrStore)
                }
            }
            
        }
    }
}

struct TTSDemoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TTSDemoDetail(asrStore: PipelineStore(text:""), ttsStore: SpeechStore())
    }
}
