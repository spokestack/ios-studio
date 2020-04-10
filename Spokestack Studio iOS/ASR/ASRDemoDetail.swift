//
//  ASRDemoDetail.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

struct ASRDemoDetail: View {
    
    //@State private var isRecording:Bool = false
    
    @ObservedObject var store:ASRDemoStore
    
     var body: some View {
        VStack {
            Spacer()
            Text(store.text).padding()
            Spacer()
            MicButtonView(store:store)
                .offset(x: 0, y: 60)
           
            recordingView()
                .transition(
                    AnyTransition.opacity.animation(Animation.linear(duration: 1))
            )
        }
    }
    
    func recordingView() -> some View {
        Group {
            if (store.isPipelineActive) {
                WaveView().frame(height: 100.0)
            } else {
                Spacer().frame(height: 108.0)
            }
        }
    }
}

struct ASRDemoDetail_Previews: PreviewProvider {
    static var previews: some View {
        ASRDemoDetail(store:ASRDemoStore(text: ""))
    }
}

