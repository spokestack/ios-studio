//
//  ListeningIcon.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 5/4/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Combine

struct ListeningIcon: View {
    
    @Binding var isListening: Bool
    
    var size: CGFloat = 58
    
    var body: some View {
        
        ZStack {
            
            ThreeDotsView(isListening: $isListening, compression: 3)
                .frame(width: size-8, height: size-8)
                .opacity(isListening ? 1.0 : 0.0)
            
            Image(systemName: "mic").font(.title)
                .opacity(isListening ? 0.0 : 1.0)
        }
        .frame(width: size, height: size)
    }
}

struct ListeningIcon_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
    
        @State var isRecording: Bool = false
        
        @State var isRecording2: Bool = true
        
        var body: some View {
        
            Group {
                HStack {
                    Button(action:{self.isRecording.toggle()}) {
                        ListeningIcon(isListening: $isRecording).cornerRadius(40)
                            
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(40)
                            .shadow(color: Color.blue, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                    
                    Button(action:{self.isRecording2.toggle()}) {
                        ListeningIcon(isListening: $isRecording2, size: 88)
                            .background(Color.yellow)
                            .foregroundColor(Color.green)
                            .cornerRadius(80)
                    }
                }.padding().environment(\.colorScheme, .light)
                HStack {
                    Button(action:{self.isRecording.toggle()}) {
                        ListeningIcon(isListening: $isRecording)
                        
                    }
                    Button(action:{self.isRecording2.toggle()}) {
                        ListeningIcon(isListening: $isRecording2)
                        
                    }
                }.padding()
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}
