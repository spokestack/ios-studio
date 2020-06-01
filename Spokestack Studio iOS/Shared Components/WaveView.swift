//
//  WaveView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Combine

struct WaveView: View {
    
    let timer: Publishers.Autoconnect = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    @State private var a1: CGFloat = 25
    
    @State private var a2 :CGFloat = 20
    
    @State private var p1: CGFloat = 0
    
    @State private var p2: CGFloat = 0
    
    @State private var t: Int = 0
    
    var body: some View {
        
        ZStack {
        
            SineWave(phase: p1, amplitude: a1, frequency: 3).opacity(0.2)//.fill(Color.gray).opacity(0.2)
            SineWave(phase: p2, amplitude: a2, frequency: 5).opacity(0.5)//.fill(Color("SpokestackBlue")).opacity(0.5)
        }.onReceive(timer) { time in
            
            self.t += 1
            let modA = CGFloat(sin(Double(self.t)/Double.pi))
            let modB = CGFloat(sin(Double(self.t)/Double.pi/2))
            
            self.a1 = 25 * modA
            self.a2 = 20 * modB
            
            self.p1 = modB
            self.p2 = modA
        }
    }
}

struct SineWave: Shape {
    
    let phase: CGFloat
    
    let amplitude: CGFloat
    
    let frequency: CGFloat /// cycles per screen width
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        let origin = CGPoint(x: 0, y: height * 0.50)

        var path = Path()
        path.move(to: origin)

        var endY: CGFloat = 0.0
        let step = 5.0
        let omega = Double(frequency / width) * 2.0 * Double.pi
        for angle in stride(from: 0, to: Double(width), by: step) {
            
            let x = origin.x + CGFloat(angle)
            let y = origin.y - CGFloat(sin(omega * angle + Double(phase))) * amplitude
            
            path.addLine(to: CGPoint(x: x, y: y))
            endY = y
        }
        path.addLine(to: CGPoint(x: width, y: endY))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: origin.y))

        return path
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView().foregroundColor(Color.blue)
    }
}
