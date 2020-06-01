//
//  WakewordDemoDetail.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/24/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI

struct WakewordDemoDetail: View {
    
    @ObservedObject var store: PipelineStore
        
    var body: some View {
        
        ZStack {
        
            Color("SpokestackBackground")
            
            VStack {
                Spacer()
                Text(self.store.text)
                    .foregroundColor(Color("SpokestackPrimary"))
                Spacer()
                
                Group {
                    if !self.store.isListening {
                        
                        Text("Say \"Spoke Stack\" to get my attention.")
                            .foregroundColor(Color("SpokestackPrimary"))
                            .font(.headline)
                        
                    } else {
                        
                        Text("Go ahead, I'm listening.")
                            .foregroundColor(Color("SpokestackPrimary"))
                            .font(.headline)
                    }
                }
                .transition(
                    AnyTransition.opacity.animation(Animation.linear(duration: 0.5))
                )
                
                Spacer()
                
                Group {
    
                    if self.store.isListening {
                        WaveView().frame(height: 100.0)
                    } else {
                        Spacer().frame(height: 108.0)
                    }
                }.transition(
                    AnyTransition.opacity.animation(Animation.linear(duration: 1))
                )
            }
        }
        .navigationBarTitle("Wake Word")
        .onAppear {
            self.store.configure(.wakeword)
        }
    }
}

struct WakewordDemoDetail_Previews: PreviewProvider {
    static var previews: some View {
        WakewordDemoDetail(store: PipelineStore(""))
    }
}
