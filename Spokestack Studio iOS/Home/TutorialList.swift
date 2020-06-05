//
//  TutorialList.swift
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
        
        let tutorials: Array<TutorialView> = [
            TutorialView(tutorial: tutorialData[0], destination: AnyView(ASRTutorialDetail(store: asrStore))),
            TutorialView(tutorial: tutorialData[1], destination: AnyView(TTSTutorialDetail(asrStore: asrStore, ttsStore: ttsStore))),
            TutorialView(tutorial: tutorialData[2], destination: AnyView(NLUTutorialDetail(asrStore: asrStore, nluStore: nluStore))),
            TutorialView(tutorial: tutorialData[3], destination: AnyView(WakewordTutorialDetail(store: asrStore))),
            TutorialView(tutorial: tutorialData[4], destination: AnyView(MinecraftTutorialDetail(dialogStore: dialogStore)))
        ]
        
        return NavigationView {

            List(tutorials) { tutorial in
                NavigationLink(destination: tutorial.destination) {
                    TutorialRow(tutorial: tutorial.tutorial)
                }
            }
            .navigationBarTitle(Text("NLU Studio"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TutorialView: Identifiable {

    let id: Int
    
    let tutorial: Tutorial
    
    let destination: AnyView

    init(tutorial: Tutorial, destination: AnyView) {
        self.id = tutorial.id
        self.tutorial = tutorial
        self.destination = destination
    }
}

struct TutorialList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            TutorialList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName).environment(\.colorScheme, .dark)
        }
    }
}
