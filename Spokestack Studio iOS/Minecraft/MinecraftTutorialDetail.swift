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
    
    @State private var uiState: UIState = .welcome
    
    @State private var dialogManager: SkillDialogController = SkillDialogController()
    
    enum UIState {
       case welcome
       case heard
       case responded
    }
       
   var body: some View {
    
        VStack {
        
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
       }
       .onAppear{
            
            self.dialogStore.nluStore.configureNLU("8436a7e", metadataName: "minecraft-metadata")
            self.dialogStore.startPipeline()
            let speak: HandlerOutput = try! self.dialogManager.turn("LaunchRequest")
            self.dialogStore.speak(speak)
       }
   }
}

struct MinecraftDemoDetail_Previews: PreviewProvider {
    static var previews: some View {

        MinecraftTutorialDetail(dialogStore: DialogStore())
                .environment(\.colorScheme, .light)
    }
}
