//
//  NLUDemoView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/14/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

struct NLUDemoDetail: View {
    
    @ObservedObject var asrStore:PipelineStore
    @ObservedObject var nluStore:NLUStore
    
    enum UIState {
        case intro
        case ready
        case listening
        case classifying
    }
    
    @State var uiState:UIState = .intro
    
    var body: some View {
        ZStack {
            Color("SpokestackBackground")
            
            if (uiState == .intro) {
                VStack {
                    Text("Natural language understanding (NLU) converts text into a an \"intent\" that your app can understand. The types of intents that your app will understand depends on the type of NLU model loaded.").font(.body).foregroundColor(Color("SpokestackPrimary")).multilineTextAlignment(.center).padding()
                    Text("Spokestack provides on-device NLU models for many use cases. This demo model is to control a camera app.").font(.body).fontWeight(.light).foregroundColor(Color("SpokestackPrimary")).multilineTextAlignment(.center).padding()
                    
                    Button(action:{withAnimation {self.uiState = .ready}}){
                            Text("Continue")
                    }.padding()
                    
                }
                Spacer()
            } else if (uiState == .listening || uiState == .ready) {
                VStack {
                    Spacer()
                    
                    Group {
                        if (uiState == .ready) {
                            Group {
                                Text("Tap the button below & speak")
                                HintArrowView(arrowheadSize:6).frame(width: 200, height: 150).foregroundColor(Color.primary)
                            }.transition(.opacity)
                        }
                        
                        MicButtonView(store:asrStore).transition(.opacity)
                    }.offset(x: 0, y: 60)
                    
                    if (uiState == .listening) {
                        WaveView().frame(height: 100.0).transition(.opacity)
                    } else if (uiState == .ready) {
                        Spacer().frame(height: 108.0).transition(.opacity)
                    }
                }
            } else {
                VStack {
                    Text("\"\(asrStore.text)\"").font(.title)
                        .foregroundColor(Color("SpokestackPrimary")).padding()
                    ClassifyingView(store:nluStore)
                    Spacer()
                    Button("Reset", action:{
                        withAnimation() {
                            self.uiState = .listening
                        }
                    }).padding()
                }.transition(.opacity)
            }
        }.navigationBarTitle("NLU")
            .onReceive(asrStore.$text) { text in
                print("received text \(text)")
                if ((text.count > 0 && self.uiState == .listening)){
                    self.nluStore.classify(text: text)
                    withAnimation() {
                        self.uiState = .classifying
                    }
                }
        }.onReceive(asrStore.$isPipelineActive, perform: { isPipelineActive in
            print("onreceive pipeline \(isPipelineActive) \(self.uiState)")
            if (isPipelineActive) {
                withAnimation{self.uiState = .listening}
            }
            
        })
    }
    
    
}

struct NLUDemoDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        
        Group {
           NLUDemoDetail(asrStore: PipelineStore(text:""), nluStore: NLUStore(result:NLUResult(utterance: "test utterance", intent: "test.utterance", confidence: 0.99)))
              .environment(\.colorScheme, .light)

           NLUDemoDetail(asrStore: PipelineStore(text:""), nluStore: NLUStore(result:NLUResult(utterance: "test utterance", intent: "test.utterance", confidence: 0.99)))
              .environment(\.colorScheme, .dark)
        }
        
    }
}
