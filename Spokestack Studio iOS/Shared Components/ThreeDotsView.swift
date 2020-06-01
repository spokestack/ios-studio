//
//  ThreeDotsView.swift
//  Spokestack Studio iOS
//
//  Created by Cory D. Wiles on 5/19/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Combine

struct ThreeDotsView: View {
    
    @Binding var isListening: Bool
    
    let compression: CGFloat
    
    var body: some View {

        HStack(spacing: -compression) {

            ForEach(0...2, id: \.self) { scale in

                Circle()
                    .scaleEffect(self.isListening ? 0.8 : 0)
                    .animation(Animation.linear(duration: 0.6).repeatForever().delay(0.25 * Double(scale)))
            }
        }
   }
}
