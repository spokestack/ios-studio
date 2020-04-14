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
   
        let asrStore = PipelineStore(text: "")
        let ttsStore = SpeechStore()
        
        let demos = [
            DemoView(demo: demoData[0], destination: AnyView(ASRDemoDetail(store: asrStore))),
            DemoView(demo: demoData[1], destination: AnyView(TTSDemoDetail(asrStore: asrStore, ttsStore: ttsStore)))
        ]
        
        return NavigationView {
            
            List(demos) { demo in
                NavigationLink(destination: demo.destination) {
                    DemoRow(demo: demo.demo)
                }
            }
            
            //.background(Color("SpokestackPrimary").edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text("Studio Demos"))
            .navigationBarItems(leading:
                Image("HeaderLogo")
            )
        }
    }
}

struct DemoView: Identifiable {

    let id: Int
    let demo: Demo
    let destination: AnyView

    init(demo: Demo, destination: AnyView) {
        self.id = demo.id
        self.demo = demo
        self.destination = destination
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
