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
    @State private var selectedModel = 0
    
    enum UIState {
        case intro
        case model
        case ready
        case listening
        case classifying
    }
    
    @State var uiState:UIState = .intro
    
    var body: some View {
        
        switchedView().background(Color("SpokestackBackground"))
            
            .navigationBarTitle("Intent Understanding")
            .onReceive(asrStore.$text) { text in
                print("received text \(text)")
                if ((text.count > 0 && self.uiState == .listening)){
                    self.nluStore.classify(text: text)
                    withAnimation() {
                        self.uiState = .classifying
                    }
                }
        }
        .onReceive(asrStore.$isListening, perform: { isListening in
            print("onreceive pipeline \(isListening) \(self.uiState)")
            if ((self.uiState == .listening) && !isListening) {
                withAnimation{self.uiState = .ready}
            } else if (isListening) {
                withAnimation{self.uiState = .listening}
            }
            
        })
            .onAppear {
                self.asrStore.configure(mode: .push2talk)
        }
    }
    
    
    func switchedView() -> some View {
        if (uiState == .intro) {
            
            return AnyView(introView())
            
        } else if (uiState == .model) {
            
            return AnyView(modelView())
            
        } else if (uiState == .listening || uiState == .ready) {
            
            return AnyView(asrView())
        } else {
            return AnyView(nluView())
        }
    }
    
    func introView() -> some View {
        VStack {
            Spacer()
            VStack {
                Text("Natural language understanding (NLU) converts text into a an \"intent\" that your app can understand. The types of intents that your app will understand depends on the type of NLU model loaded.").font(.body).multilineTextAlignment(.center).padding()
                
            }.background(/*@START_MENU_TOKEN@*/Color("SpokestackForeground")/*@END_MENU_TOKEN@*/).cornerRadius(10).padding()
            Spacer()
            Button(action:{withAnimation {self.uiState = .model}}){
                Text("Continue").foregroundColor(Color.white).padding().padding(.horizontal, 20.0)
            }.background(Color("SpokestackBlue")).cornerRadius(20).shadow(color: Color("SpokestackBlue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Spacer()
        }
    }
    
    func modelView() -> some View {
        
        Group {
            Form {
                
                Section {
                    Text("Spokestack provides on-device NLU models for many use cases. ").font(.body).fontWeight(.light).foregroundColor(Color("SpokestackPrimary")).padding(.top)
                    Picker("Model", selection: $selectedModel) {
                        ForEach(0 ..< modelData.count) {
                            Text(modelData[$0].name)
                        }
                    }.labelsHidden()
                }
                
                Section(header: Text("Model Description")) {
                    Text(modelData[selectedModel].description)
                    
                }
                Section(header: Text("Examples")) {
                    ForEach(modelData[selectedModel].examples, id: \.self) { example in
                        Text("\"\(example)\"")
                        
                    }
                }
                
                
            }
            
            Button(action:{
                
                self.nluStore.configureNLU(modelName: modelData[self.selectedModel].modelFile, metadataName: modelData[self.selectedModel].metadataFile)
                withAnimation {self.uiState = .ready}
            })
            {
                Text("Continue").foregroundColor(Color.white).padding().padding(.horizontal, 20.0)
            }.background(Color("SpokestackBlue")).cornerRadius(20).shadow(color: Color("SpokestackBlue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/).padding()
            
        }
    }
    
    func asrView() -> some View {
        VStack {
            Spacer()
            
            Group {
                if (uiState == .ready) {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Tap the button below & speak")
                            HintArrowView(arrowheadSize:6).frame(width: 200, height: 150).foregroundColor(Color.primary)
                        }.transition(.opacity)
                        Spacer()
                    }
                }
                
                Button(action:{
                    if (self.asrStore.isListening) {
                        self.asrStore.deactivatePipeline()
                    } else {
                        self.asrStore.activatePipeline()
                    }
                    
                }) {
                    ListeningIcon(isListening:$asrStore.isListening)
                        .foregroundColor(Color.white)
                    .background(Color("SpokestackBlue"))
                    .cornerRadius(40)
                    .shadow(color: Color("SpokestackBlue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }.transition(.opacity)
            }.offset(x: 0, y: 60)
            
            if (uiState == .listening) {
                WaveView().foregroundColor(Color("SpokestackBlue")).frame(height: 100.0).transition(.opacity)
            } else if (uiState == .ready) {
                Spacer().frame(height: 108.0).transition(.opacity)
            }
        }
    }
    
    func nluView() -> some View{
        VStack {
            Text("\"\(asrStore.text)\"").font(.title)
                .foregroundColor(Color("SpokestackPrimary")).padding()
            ClassifyingView(store:nluStore)
            Spacer()
            Button("Try Again", action:{
                withAnimation() {
                    self.uiState = .ready
                }
            }).padding()
            Button("Change Model", action:{
                withAnimation() {
                    self.uiState = .model
                }
            }).padding()
        }.transition(.opacity)
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
