//
//  SkillDialogController.swift
//  Spokestack Studio iOS
//
//  Created by Cory D. Wiles on 6/2/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import Foundation
import Spokestack
import Fuse

protocol RequestHandler {
    
    func canHandle(_ handlerInput:HandlerInput) -> Bool
    func handle(_ handlerInput:HandlerInput) -> HandlerOutput
}

enum DialogError: Error {
    case unhandled
}

struct HandlerInput {
    
    var type: String
    
    var intent: NLUResult?
    
    var session: Session
}

struct HandlerOutput {
    
    var speak: String
    
    var reprompt: String?
}

struct Session {
    
    var speakOutput: String?
    
    var repromptSpeech: String?
}

struct LaunchRequestHandler: RequestHandler {
    
    func canHandle(_ handlerInput: HandlerInput) -> Bool {
        return handlerInput.type == "LaunchRequest"
    }
    
    func handle(_ handlerInput: HandlerInput) -> HandlerOutput {
        
        let item: String = recipes.randomElement()!.key
        let speak = String(format: responses["WELCOME_MESSAGE"]!, responses["SKILL_NAME"]! ,item)
        
        return HandlerOutput(speak: speak, reprompt: responses["WELCOME_REPROMPT"])
    }
}

struct RecipeHandler: RequestHandler {
    
    func canHandle(_ handlerInput: HandlerInput) -> Bool {
        return (handlerInput.type == "IntentRequest" && handlerInput.intent!.intent == "RecipeIntent")
    }
    
    func handle(_ handlerInput: HandlerInput) -> HandlerOutput {

        let item: Slot? = handlerInput.intent!.slots?["item"]
        
        print("got item \(String(describing: item))")
        let repromptSpeech: String = responses["RECIPE_NOT_FOUND_REPROMPT"]!
        
        guard let itemSlot: Slot = item,
            let itemValue: String = itemSlot.value as? String else {
            
                return HandlerOutput(speak: responses["RECIPE_NOT_FOUND_WITHOUT_ITEM_NAME"]! + repromptSpeech, reprompt: repromptSpeech)
        }

        print("got value \(itemValue)")
        
        let fuse: Fuse = Fuse(threshold:0.3)
        let keys: Array<String> = Array(recipes.keys)
        
        /// let's do a fuzzy match to deal with an imperfect ASR
        let results = fuse.search(itemValue, in: keys)

        results.forEach { item in
            print("score: \(item.score) - \(keys[item.index])")
        }
        
        var recipe: String?
        
        if !results.isEmpty {
            recipe = recipes[keys[results[0].index]]
        }
        
        if recipe != nil {
            
            return HandlerOutput(speak: recipe!)

        } else {

            let speak: String = String(format: responses["RECIPE_NOT_FOUND_WITH_ITEM_NAME"]!,itemValue)
            return HandlerOutput(speak: speak + repromptSpeech, reprompt: repromptSpeech)
        }
    }
}

struct HelpHandler: RequestHandler {
    
    func canHandle(_ handlerInput: HandlerInput) -> Bool {
        return (handlerInput.type == "IntentRequest" && handlerInput.intent!.intent == "AMAZON.HelpIntent")
    }
    
    func handle(_ handlerInput: HandlerInput) -> HandlerOutput {
        
        let item: String = recipes.randomElement()!.key
        let speak: String = String(format: responses["HELP_MESSAGE"]!,item)
        
        return HandlerOutput(speak: speak, reprompt: responses["HELP_REPROMPT"])
    }
}

struct RepeatHandler: RequestHandler {
    
    func canHandle(_ handlerInput: HandlerInput) -> Bool {
        return (handlerInput.type == "IntentRequest" && handlerInput.intent!.intent == "AMAZON.RepeatIntent")
    }
    
    func handle(_ handlerInput: HandlerInput) -> HandlerOutput {
        return HandlerOutput(speak: handlerInput.session.speakOutput!, reprompt: handlerInput.session.repromptSpeech)
    }
}

struct ExitHandler: RequestHandler {
    
    func canHandle(_ handlerInput: HandlerInput) -> Bool {
        
        if handlerInput.type == "IntentRequest" {
            return (handlerInput.intent!.intent == "AMAZON.StopIntent") || (handlerInput.intent!.intent == "AMAZON.CancelIntent")
        } else {
            return false
        }
    }
    
    func handle(_ handlerInput: HandlerInput) -> HandlerOutput {
        
        let speak: String = String(format: responses["STOP_MESSAGE"]!)
        return HandlerOutput(speak: speak)
    }
}

struct ErrorHandler: RequestHandler {
    
    func canHandle(_ handlerInput: HandlerInput) -> Bool {
        return true
    }
    
    func handle(_ handlerInput: HandlerInput) -> HandlerOutput {
        
        return HandlerOutput(speak: "Sorry, I can\'t understand the command. Please say again.",
                             reprompt: "Sorry, I can\'t understand the command. Please say again.")
    }
}

class SkillDialogController {
    
    var session: Session = Session()
    
    var handlers: Array<RequestHandler> = [
        LaunchRequestHandler(),
        RecipeHandler(),
        HelpHandler(),
        RepeatHandler(),
        ExitHandler(),
        ErrorHandler()
    ]
    
    func turn(_ type: String, nluResult: NLUResult? = nil, error: Error? = nil) throws -> HandlerOutput {
        
        let handlerInput: HandlerInput = HandlerInput(type: type, intent: nluResult, session: session)
        
        for handler in self.handlers {
            
            if handler.canHandle(handlerInput) {
            
                let output = handler.handle(handlerInput)
                self.session.speakOutput = output.speak
                self.session.repromptSpeech = output.reprompt
                
                return output
            }
        }
        
        throw DialogError.unhandled
    }
}
