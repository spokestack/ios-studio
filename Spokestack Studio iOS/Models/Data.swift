//
//  Data.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import Foundation

let demoData: Array<Demo> = load("demoData.json")
let modelData: Array<NLUModel> = load("modelData.json")

func load<T: Decodable>(_ filename: String) -> T {
    
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
    
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)

    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
