//
//  DemoList.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct DemoList: View {
    
    init() {
        
        UITableViewCell.appearance().backgroundColor = UIColor(named: "SpokestackBackground")
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
   
        let asrStore: PipelineStore = PipelineStore("")
        asrStore.startPipeline()
        
        let ttsStore: SpeechStore = SpeechStore()
        let nluStore: NLUStore = NLUStore(nil)
        
        let demos: Array<DemoView> = [
            DemoView(demo: demoData[0], destination: AnyView(ASRDemoDetail(store: asrStore))),
            DemoView(demo: demoData[1], destination: AnyView(TTSDemoDetail(asrStore: asrStore, ttsStore: ttsStore))),
            DemoView(demo: demoData[2], destination: AnyView(NLUDemoDetail(asrStore: asrStore, nluStore: nluStore))),
            DemoView(demo: demoData[3], destination: AnyView(WakewordDemoDetail(store: asrStore)))
        ]
        
        return NavigationView {

            List(demos) { demo in
                NavigationLink(destination: demo.destination) {
                    DemoRow(demo: demo.demo)
                }
            }
            .navigationBarTitle(Text("Spokestack Demos"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                .previewDisplayName(deviceName).environment(\.colorScheme, .dark)
        }
    }
}
