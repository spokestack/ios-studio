//
//  NLUModel.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/27/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import Foundation

struct NLUModel: Hashable, Codable, Identifiable {
    
    var id: Int
    
    var name: String
    
    var description: String
    
    var revision: String
    
    var examples: Array<String>
    
    var modelFile: String
    
    var metadataFile: String
}
