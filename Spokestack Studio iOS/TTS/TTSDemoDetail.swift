//
//  TTSDemoDetail.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/13/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct TTSDemoDetail: View {
    
    @ObservedObject var asrStore: PipelineStore
    
    @ObservedObject var ttsStore: SpeechStore
    
    enum UIState {
        case intro
        case ready
        case listening
        case synthesizing
        case speaking
    }
    
    @State var uiState: UIState = .intro
    
    var body: some View {
        
        ZStack {
            Color("SpokestackBackground")
            VStack {
                
                Spacer()
                
                if self.uiState == .intro {
                    VStack {
                        Text("Speech transfer will take the words you speak and repeat them back with a synthesized voice.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        Text("What you hear is the free Spokestack voice. Spokestack can also build a custom synthesized voice for you from audio recordings.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                    }
                    .background(Color("SpokestackForeground"))
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                    
                    Button(action:{
                        
                        withAnimation {
                            self.uiState = .ready
                        }
                    }){
                        Text("Continue")
                            .foregroundColor(Color.white)
                            .padding()
                            .padding(.horizontal, 20.0)
                    }
                    .background(Color("SpokestackBlue"))
                    .cornerRadius(20)
                    .shadow(color: Color("SpokestackBlue"), radius: 10)
                    
                    Spacer()
                }
                
                if (self.uiState == .synthesizing || self.uiState == .speaking) {
                    
                    Text(self.asrStore.text)
                        .font(.title)
                        .foregroundColor(Color("SpokestackPrimary"))
                        .padding()
                    
                    if self.uiState == .synthesizing {
                    
                        Text("Synthesizing...")
                            .fontWeight(.light)
                            .foregroundColor(Color("SpokestackPrimary"))
                            .padding()
                    }
                    Spacer()
                }
                
                Group {
                    
                    if self.uiState == .ready {
                    
                        Group {
                        
                            Text("Tap the button below & speak")
                            HintArrowView(arrowheadSize: 6)
                                .frame(width: 200, height: 150)
                                .foregroundColor(Color.primary)
                        }
                        .transition(.opacity)
                    }
                    
                    if self.uiState == .ready || self.uiState == .listening {
                        
                        Button(action:{
                            
                            if self.asrStore.isListening {
                                self.asrStore.deactivatePipeline()
                            } else {
                                self.asrStore.activatePipeline()
                            }
                            
                        }) {
                            ListeningIcon(isListening: self.$asrStore.isListening)
                                .foregroundColor(Color.white)
                                .background(Color("SpokestackBlue"))
                                .cornerRadius(40)
                                .shadow(color: Color("SpokestackBlue"), radius: 10)
                        }
                        .transition(.opacity)
                    }
                }
                .offset(x: 0, y: 60)
                
                if (self.uiState == .listening || self.uiState == .synthesizing || self.uiState == .speaking) {
                    
                    WaveView()
                        .foregroundColor(Color("SpokestackBlue"))
                        .frame(height: 100.0)
                        .transition(.opacity)

                } else if self.uiState == .ready {
                    
                    Spacer()
                        .frame(height: 108.0)
                        .transition(.opacity)
                }

            }.onReceive(self.asrStore.$text, perform: { text in
                
                print("onreceive \(text) \(self.uiState)")
                
                if (!text.isEmpty && self.uiState == .listening) {
                
                    withAnimation{
                        self.uiState = .synthesizing
                    }
                    self.ttsStore.speak(text)
                }

            }).onReceive(self.asrStore.$isListening, perform: { isListening in
                
                print("onreceive pipeline \(isListening) \(self.uiState)")
                
                if isListening {
                    withAnimation{self.uiState = .listening}
                }
            })
            .onReceive(self.ttsStore.$isSpeaking, perform: { isSpeaking in
                
                print("onreceive speaking \(isSpeaking) \(self.uiState)")
                
                withAnimation{
                
                    if (isSpeaking == false && self.uiState == .speaking) {
                        self.uiState = .ready
                    } else if isSpeaking == true {
                        self.uiState = .speaking
                    }
                }
            })
        }
        .navigationBarTitle("Voice Transfer")
        .onAppear {
            self.asrStore.configure(.push2talk)
        }
    }
}

struct TTSDemoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TTSDemoDetail(asrStore: PipelineStore(""), ttsStore: SpeechStore())
    }
}
