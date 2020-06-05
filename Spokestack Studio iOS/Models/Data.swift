//
//  Data.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import Foundation

let demoData: Array<Tutorial> = load("tutorialData.json")
let modelData: Array<NLUModel> = load("modelData.json")
let recipes: Dictionary<String, String> = load("minecraft-recipe.json")

let responses: Dictionary<String, String> = [
    "SKILL_NAME": "Minecraft Helper",
    "WELCOME_MESSAGE": "Welcome to %@. You can ask a question like, what\'s the recipe for a %@? ... Now, what can I help you with?",
    "WELCOME_REPROMPT": "For instructions on what you can say, please say help me.",
    "DISPLAY_CARD_TITLE": "%@  - Recipe for %@.",
    "HELP_MESSAGE": "You can ask questions such as, what\'s the recipe for a %@, or, you can say exit...Now, what can I help you with?",
    "HELP_REPROMPT": "You can say things like, what\'s the recipe for a %@, or you can say exit...Now, what can I help you with?",
    "STOP_MESSAGE": "Goodbye!",
    "RECIPE_REPEAT_MESSAGE": "Try saying repeat.",
    "RECIPE_NOT_FOUND_WITH_ITEM_NAME": "I\'m sorry, I currently do not know the recipe for %@. ",
    "RECIPE_NOT_FOUND_WITHOUT_ITEM_NAME": "I\'m sorry, I currently do not know that recipe. ",
    "RECIPE_NOT_FOUND_REPROMPT": "What else can I help with?",
]

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
