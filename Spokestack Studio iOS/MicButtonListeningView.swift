//
//  MicButtonListeningView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI


struct MicButtonListeningView: View {
    
    static let minScale:CGFloat = 0.5
    
    @State private var scale0: CGFloat = minScale
    @State private var scale1: CGFloat = minScale
    @State private var scale2: CGFloat = minScale
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var state = 0
    
    let compression: CGFloat
    
    var body: some View {
        
        let circle1 = Circle().fill(Color.white).scaleEffect(scale0).animation(Animation.spring())
        let circle2 = Circle().fill(Color.white).scaleEffect(scale1).animation(Animation.spring())
        let circle3 = Circle().fill(Color.white).scaleEffect(scale2).animation(Animation.spring())
        
        return HStack(spacing: -compression) {
            circle1
            circle2
            circle3
            }.onReceive(timer) { time in
            if self.state == 2 {
                
                self.scale1 = MicButtonListeningView.minScale
                self.scale2 = 1
                
                self.state = 0
            } else if self.state == 1 {
                
                self.scale0 = MicButtonListeningView.minScale
                self.scale1 = 1
                
                self.state = 2
            } else {
                
                self.scale2 = MicButtonListeningView.minScale
                self.scale0 = 1
                
                self.state = 1
            }
        }
        
   }
}

struct MicButtonListeningView_Previews: PreviewProvider {
    static var previews: some View {
        MicButtonListeningView(compression: 20.0).background(Color("SpokestackPrimary"))
    }
}
