//
//  MicButtonView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct MicButtonView: View {
    
    //@Binding var isRecording: Bool
    @ObservedObject var store:PipelineStore
    
    var body: some View {
        VStack {
            Button(action: {
                if (self.store.isListening) {
                    self.store.deactivatePipeline()
                } else {
                    self.store.activatePipeline()
                }
            }) {
                HStack {
                    if (store.isListening) {
                        MicButtonListeningView(compression: 3).frame(width: 58, height: 58)
                    } else {
                        Image(systemName: "mic").font(.title)
                    }
                }
                .padding(store.isListening ? 10 : 30.0)
                .foregroundColor(Color.white)
                .background(Color("SpokestackBlue"))
                .cornerRadius(40)
                .shadow(color: Color("SpokestackBlue"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
                
        }
    }
}

struct MicButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
      @State var isRecording: Bool = false

      var body: some View {
        Group {
        MicButtonView(store: PipelineStore(text: "")).environment(\.colorScheme, .light)
            MicButtonView(store: PipelineStore(text: "")).environment(\.colorScheme, .dark)
        }
      }
    }
}
