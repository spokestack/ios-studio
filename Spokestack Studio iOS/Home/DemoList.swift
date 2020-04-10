//
//  DemoList.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct DemoList: View {
    
    
    var body: some View {
        
        let store = ASRDemoStore(isRecording: false, text: "")
        
        return NavigationView {
            List(demoData) { demo in
                NavigationLink(destination: ASRDemoDetail(store:store)) {
                    DemoRow(demo: demo)
                }
            }
            .navigationBarTitle(Text("Spokestack"))
        }
    }
}

struct DemoList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            DemoList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
