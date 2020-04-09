//
//  DemoRow.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct DemoRow: View {
    
    var demo:Demo
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(demo.name)
                .font(.headline)
            Text(demo.description)
                .font(.subheadline)
        }.padding(.vertical)
    }
}

struct DemoRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DemoRow(demo: demoData[0])
            DemoRow(demo: demoData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
