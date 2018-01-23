import PerfectHTTP
import Foundation

class GreetingHandler{
    
    static func create(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let greetingParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(greetingParam),
                let greetingDictionary = jsonObject["greeting"] as? [String:Any],
                let type = greetingDictionary["type"] as? Int,
                let message = greetingDictionary["message"] as? String,
                let date = greetingDictionary["date"] as? String,
                let userId = jsonObject["id_user"] as? Int {
                do {
                    let greetingString = "{\"type\":\(type),\"message\":\"\(message)\",\"date\":\"\(date)\"}"
                    let greetingData = greetingString.data(using: .utf8)!
                    let greetingFromData = try decoder.decode(Greeting.self, from: greetingData)
                    if let createdGreeting = GreetingQuery.create(greetingFromData, userId: userId) {
                        do {
                            let createdGreetingData = try encoder.encode(createdGreeting)
                            let createdGreetingString = String(data: createdGreetingData, encoding: .utf8) ?? "{}"
                            response.appendBody(string: createdGreetingString)
                            response.completed()
                        } catch {
                            ErrorsManager.returnError(log: "Error while encoding greeting: \(error).", message: "Internal server error.", response: response)
                        }
                    } else {
                        ErrorsManager.returnError(log: "Error while creating greeting.", message: "Error while creating greeting.", response: response)
                    }
                } catch {
                    ErrorsManager.returnError(log: "Error while encoding greeting: \(error).", message: "Wrong format in request body content.", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing greeting data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func read(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            let greetings = GreetingQuery.read()
            if let completeParam = request.param(name: "complete"), let isComplete = Bool(completeParam), isComplete {
                for greeting in greetings {
                    greeting.creator = UserQuery.readByGreetingId(greeting.id ?? 0)
                }
            }
            let greetingsData = try encoder.encode(greetings)
            let greetingsDataString = String(data: greetingsData, encoding: .utf8) ?? "{}"
            response.appendBody(string: greetingsDataString)
            response.completed()
        } catch {
            ErrorsManager.returnError(log: "Erro while encoding greetings: \(error).", message: "Internal server error.", response: response)
        }
    }
    
    static func readById(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let greetingId = request.urlVariables["id"], let greetingIdAsInt = Int(greetingId) {
            if let greeting = GreetingQuery.readById(greetingIdAsInt){
                do {
                    if let completeParam = request.param(name: "complete"), let isComplete = Bool(completeParam), isComplete {
                        greeting.creator = UserQuery.readByGreetingId(greeting.id ?? 0)
                    }
                    let greetingData = try encoder.encode(greeting)
                    let greetingDataString = String(data: greetingData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: greetingDataString)
                    response.completed()
                } catch {
                    ErrorsManager.returnError(log: "Erro while encoding greeting: \(error).", message: "Internal server error.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Greeting not found.", message: "Greeting not found.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
        }
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let greetingParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(greetingParam) {
                if let greetingId = jsonObject["id_greeting"] as? Int, let message = jsonObject["message"] as? String {
                    do {
                        if let updatedGreeting = GreetingQuery.update(greetingId: greetingId, newMessage: message) {
                            let updatedGreetingData = try encoder.encode(updatedGreeting)
                            let updatedGreetingString = String(data: updatedGreetingData, encoding: .utf8) ?? "{}"
                            response.appendBody(string: updatedGreetingString)
                            response.completed()
                        } else {
                            ErrorsManager.returnError(log: "Erro while updating greeting.", message: "Erro while updating greeting.", response: response)
                        }
                    } catch {
                        ErrorsManager.returnError(log: "Error while encoding greeting: \(error).", message: "Internal server error.", response: response)
                    }
                } else {
                    ErrorsManager.returnError(log: "Argument missing.", message: "Argument missing", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing greeting data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func delete(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let  greetingId = request.urlVariables["id"] {
            if let greetingIdAsInt = Int(greetingId){
                if let deletedGreeting = GreetingQuery.delete(greetingIdAsInt){
                    do {
                        let deletedGreetingData = try encoder.encode(deletedGreeting)
                        let deletedGreetingString = String(data: deletedGreetingData, encoding: .utf8) ?? "{}"
                        response.appendBody(string: deletedGreetingString)
                        response.completed()
                    } catch {
                        ErrorsManager.returnError(log: "Erro while encoding greeting: \(error).", message: "Internal server error.", response: response)
                    }
                }else{
                    ErrorsManager.returnError(log: "Error while deleting greeting by id.", message: "Error while deleting greeting by id.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Missing id argument.", message: "Missing id argument.", response: response)
        }

    }
    
}
