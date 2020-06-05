//
//  DemoList.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct TutorialList: View {
    
    init() {
        
        UITableViewCell.appearance().backgroundColor = UIColor(named: "SpokestackBackground")
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
   
        let asrStore: PipelineStore = PipelineStore("")
        asrStore.startPipeline()
        
        let ttsStore: SpeechStore = SpeechStore()
        let nluStore: NLUStore = NLUStore(nil)
        let dialogStore: DialogStore = DialogStore()
        
        let demos: Array<TutorialView> = [
            TutorialView(demo: demoData[0], destination: AnyView(ASRTutorialDetail(store: asrStore))),
            TutorialView(demo: demoData[1], destination: AnyView(TTSTutorialDetail(asrStore: asrStore, ttsStore: ttsStore))),
            TutorialView(demo: demoData[2], destination: AnyView(NLUTutorialDetail(asrStore: asrStore, nluStore: nluStore))),
            TutorialView(demo: demoData[3], destination: AnyView(WakewordTutorialDetail(store: asrStore))),
            TutorialView(demo: demoData[4], destination: AnyView(MinecraftTutorialDetail(dialogStore: dialogStore)))
        ]
        
        return NavigationView {

            List(demos) { demo in
                NavigationLink(destination: demo.destination) {
                    TutorialRow(demo: demo.demo)
                }
            }
            .navigationBarTitle(Text("Spokestack Demos"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TutorialView: Identifiable {

    let id: Int
    
    let demo: Tutorial
    
    let destination: AnyView

    init(demo: Tutorial, destination: AnyView) {
        self.id = demo.id
        self.demo = demo
        self.destination = destination
    }
}

struct DemoList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            TutorialList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName).environment(\.colorScheme, .dark)
        }
    }
}
