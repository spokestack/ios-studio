//
//  HintArrowView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/17/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct HintArrowView: View {
    
    var arrowheadSize: CGFloat
    
    var body: some View {
        HintArrow(arrowheadSize:arrowheadSize)
        .stroke()
    }
    
    struct HintArrow: Shape {
        
        var arrowheadSize: CGFloat
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x:rect.width / 2, y: 0))

            path.addLine(to: CGPoint(x:rect.width / 2, y: rect.height - arrowheadSize*2))
            
            path.move(to: CGPoint(x:rect.width / 2 + arrowheadSize, y: rect.height - arrowheadSize*2.5))
            
            path.addLine(to: CGPoint(x:rect.width / 2, y: rect.height - arrowheadSize))
            
            path.move(to: CGPoint(x:rect.width / 2 - arrowheadSize, y: rect.height - arrowheadSize*2.5))
            
            path.addLine(to: CGPoint(x:rect.width / 2, y: rect.height - arrowheadSize))

            return path
        }
    }
}

struct HintArrowView_Previews: PreviewProvider {
    static var previews: some View {
        HintArrowView(arrowheadSize: 10).frame(width: 200, height: 200)
    }
}
