//
//  ListeningIcon.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 5/4/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct ListeningIcon: View {
    
    @Binding var isListening: Bool
    var size:CGFloat = 58
    
    var body: some View {
        
        return HStack {
            if (isListening) {
                ThreeDotsView(compression: 3).frame(width: size-8, height: size-8)
            } else {
                Image(systemName: "mic").font(.title)
            }
        }.frame(width: size, height: size)

    }
    
    struct ThreeDotsView: View {
        
        static let minScale:CGFloat = 0.5
        
        @State private var scale0: CGFloat = minScale
        @State private var scale1: CGFloat = minScale
        @State private var scale2: CGFloat = minScale
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State private var state = 0
        
        let compression: CGFloat
        
        var body: some View {
            
            let circle1 = Circle().scaleEffect(scale0).animation(Animation.spring())
            let circle2 = Circle().scaleEffect(scale1).animation(Animation.spring())
            let circle3 = Circle().scaleEffect(scale2).animation(Animation.spring())
            
            return HStack(spacing: -compression) {
                circle1
                circle2
                circle3
                }.onReceive(timer) { time in
                    if self.state == 2 {
                        
                        self.scale1 = ThreeDotsView.minScale
                        self.scale2 = 1
                        
                        self.state = 0
                    } else if self.state == 1 {
                        
                        self.scale0 = ThreeDotsView.minScale
                        self.scale1 = 1
                        
                        self.state = 2
                    } else {
                        
                        self.scale2 = ThreeDotsView.minScale
                        self.scale0 = 1
                        
                        self.state = 1
                    }
            }
            
       }
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
