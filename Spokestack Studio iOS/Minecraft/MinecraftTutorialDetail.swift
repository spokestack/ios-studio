//
//  MinecraftDetail.swift
//  Spokestack Studio iOS
//
//  Created by Cory D. Wiles on 6/2/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import Foundation
import SwiftUI
import Spokestack

struct MinecraftTutorialDetail: View {
    
    @ObservedObject var dialogStore: DialogStore
    
    @State private var uiState: UIState = .intro
    
    @State private var dialogManager: SkillDialogController = SkillDialogController()
    
    enum UIState {
        case intro
        case welcome
        case heard
        case responded
    }
    
    var body: some View {
        
        VStack {
            if self.uiState == .intro {
                VStack {
                    Text("You can build smart-speaker style voice apps on mobile by combining ASR, NLU, and TTS. This is a direct port of an Alexa example skill called Minecraft Helper.")
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
                        self.uiState = .welcome
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
            } else {
                
                
                VStack(alignment: .leading) {
                    
                    if dialogStore.userSays != nil {
                        Text(dialogStore.userSays!).transition(.opacity).padding(32).font(.subheadline)
                    }
                    
                    if dialogStore.appSays != nil {
                        Text(dialogStore.appSays!).transition(.opacity).padding().font(.headline)
                    }
                }
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                
                Spacer()
                
                Button(action:{
                    
                    if self.dialogStore.isListening {
                        self.dialogStore.deactivatePipeline()
                    } else {
                        self.dialogStore.activatePipeline()
                    }
                    
                }) {
                    ListeningIcon(isListening: self.$dialogStore.isListening)
                        .foregroundColor(Color.white)
                        .background(Color("SpokestackBlue"))
                        .cornerRadius(40)
                        .shadow(color: Color("SpokestackBlue"), radius: 10)
                }
                
                Spacer()
                    .frame(height: 48.0)
                    
                    .onAppear{
                        
                        self.dialogStore.nluStore.configureNLU("minecraft-model", metadataName: "minecraft-metadata")
                        self.dialogStore.startPipeline()
                        let speak: HandlerOutput = try! self.dialogManager.turn("LaunchRequest")
                        self.dialogStore.speak(speak)
                }
            }
        }
    }
}


struct MinecraftTutorialDetail_Previews: PreviewProvider {
    static var previews: some View {

        MinecraftTutorialDetail(dialogStore: DialogStore())
                .environment(\.colorScheme, .light)
    }
}
