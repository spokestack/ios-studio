//
//  ClassifyingView.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/15/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

struct ClassifyingView: View {

    @ObservedObject var store: NLUStore
    
    var body: some View {
        
        VStack {
        
            if self.store.error != nil {
                
                Text("Failure: \(self.store.error!.localizedDescription)")
                    .font(.body)
                    .foregroundColor(Color.red)

            } else if self.store.result != nil {

                self.intentSection()
                self.slotsSection()
            }
        }
    }
    
    // MARK: Private (methods)
    
    private func row(_ key: String, value: String) -> some View {
        
        VStack(alignment: .leading) {
        
            HStack {
                
                Text(key)
                    .font(.subheadline)
                    
                Spacer()
                Text(value)
                    .fontWeight(.thin)
            }
            Divider()
        }
        .padding(.horizontal, 8)
    }
    
    private func intentSection() -> some View {
        
        Group {
        
            Group {
                HStack {
                    Text("Classification")
                        .font(.headline)
                        .foregroundColor(Color("SpokestackPrimary"))
                    Spacer()
                }
                Divider()
            }
            .padding([.top, .leading, .trailing], 8)
            
            self.row("Intent",value: store.result!.intent)
            self.row("Confidence",value: String(format: "%.2f", store.result!.confidence))
            self.row("Time",value: String(format: "%.2fms", store.benchmark))
        }
    }
    
    private func slotsSection() -> some View {
        
        let slots = store.result!.slots?.sorted{$0.key < $1.key} ?? []
        
        return Group {
            
            Group {
            
                HStack {
                    Text("Slots")
                        .font(.headline)
                        .foregroundColor(Color("SpokestackPrimary"))
                    Spacer()
                }
                Divider()
            }
            .padding([.top, .leading, .trailing], 8)
            
            ForEach(slots, id: \.0) { index, item in
                self.row(index, value: item.description)
            }
        }
    }
}

struct ClassifyingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = NLUStore(NLUResult(utterance: "test utterance", intent: "test.utterance", confidence: 0.99))
        let view = ClassifyingView(store:store)
        //store.classify(text: "Set a timer for 15 seconds")
        return view
    }
}

