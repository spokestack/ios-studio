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

    @ObservedObject var store:NLUStore
    
    var body: some View {
        VStack {
            if (store.error != nil) {
                Text("Failure: \(store.error!.localizedDescription)")
                    .font(.body)
                    .foregroundColor(Color.red)
            } else if (store.result != nil) {
                intentSection()
                slotsSection()
            }
            
        }
    }
    
    func row(key:String, value:String) -> some View {
        VStack(alignment: .leading) {
            HStack{
                Text(key)
                    .font(.subheadline)
                    
                Spacer()
                Text(value)
                    .fontWeight(.thin)
            }
            Divider()
        }.padding(.horizontal, 8)
    }
    
    func intentSection() -> some View {
        Group {
            Group {
                HStack {
                    Text("Classification").font(.headline).foregroundColor(Color("SpokestackPrimary"))
                    Spacer()
                }
                Divider()
            }.padding([.top, .leading, .trailing], 8)
            row(key:"Intent",value:store.result!.intent)
            row(key:"Confidence",value:String(format: "%.2f", store.result!.confidence))
            row(key:"Time",value:String(format: "%.2fms", store.benchmark))
            
        }
    }
    
    func slotsSection() -> some View {
        
        let slots = store.result!.slots?.sorted{$0.key < $1.key} ?? []
        
        return Group {
            Group {
                HStack {
                    Text("Slots").font(.headline).foregroundColor(Color("SpokestackPrimary"))
                    Spacer()
                }
                Divider()
            }.padding([.top, .leading, .trailing], 8)
            
            ForEach(slots, id: \.0) { index, item in
                self.row(key: index, value: item.description)
            }
            
        }
        
        
    }
    
}

struct ClassifyingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = NLUStore(result:NLUResult(utterance: "test utterance", intent: "test.utterance", confidence: 0.99))
        let view = ClassifyingView(store:store)
        //store.classify(text: "Set a timer for 15 seconds")
        return view
    }
}

