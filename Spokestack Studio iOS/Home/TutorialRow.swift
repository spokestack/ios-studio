//
//  TutorialRow.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct TutorialRow: View {
    
    var tutorial: Tutorial
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(self.tutorial.name)
                .font(.headline)
            Text(self.tutorial.description)
                .font(.subheadline)
        }
        .padding(.vertical)
    }
}

struct TutorialRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TutorialRow(tutorial: tutorialData[0])
            TutorialRow(tutorial: tutorialData[1])
        }
        .previewLayout(.fixed(width: 300, height: 400))
    }
}
