//
//  MicButtonView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct MicButtonView: View {
    
    @Binding var isRecording: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                self.isRecording.toggle()
            }) {
                HStack {
                    if (self.isRecording) {
                        MicButtonListeningView(compression: 3).frame(width: 58, height: 58)
                    } else {
                        Image(systemName: "mic").font(.title)
                    }
                }
                .padding(self.isRecording ? 10 : 30.0)
                .foregroundColor(.white)
                .background(Color("SpokestackPrimary"))
                .cornerRadius(40)
                .shadow(color: Color("SpokestackPrimary"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
        MicButtonView(isRecording: $isRecording)
      }
    }
}