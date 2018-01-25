import PerfectHTTP
import Foundation

class InteractionHandler{
    
    static func create(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let interactionParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(interactionParam) {
                if let receiverId = jsonObject["id_receiver"] as? Int, let greetingId = jsonObject["id_greeting"] as? Int {
                    if let createdInteraction = InteractionQuery.create(greetingId: greetingId, receiverId: receiverId) {
                        do {
                            let createdInteractionData = try encoder.encode(createdInteraction)
                            let createdInteractionString = String(data: createdInteractionData, encoding: .utf8) ?? "{}"
                            response.appendBody(string: createdInteractionString)
                            response.completed()
                        } catch {
                            ErrorsManager.returnError(log: "Error while encoding interaction: \(error).", message: "Internal server error.", response: response)
                        }
                    } else {
                        ErrorsManager.returnError(log: "Error while creating interaction.", message: "Error while creating interaction.", response: response)
                    }
                } else {
                    ErrorsManager.returnError(log: "Argument missing.", message: "Argument missing", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing interaction data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func read(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            let interactions = InteractionQuery.read()
            if let completeParam = request.param(name: "complete"), let isComplete = Bool(completeParam), isComplete {
                for interaction in interactions {
                    interaction.greeting?.creator = UserQuery.readByGreetingId(interaction.greeting?.id ?? 0)
                }
            }
            let interactionsData = try encoder.encode(interactions)
            let interactionsDataString = String(data: interactionsData, encoding: .utf8) ?? "{}"
            response.appendBody(string: interactionsDataString)
            response.completed()
        } catch {
            ErrorsManager.returnError(log: "Erro while encoding interactions: \(error).", message: "Internal server error.", response: response)
        }
    }
    
    static func readById(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let interactionId = request.urlVariables["id"], let interactionIdAsInt = Int(interactionId) {
            if let interaction = InteractionQuery.readById(interactionIdAsInt){
                do {
                    if let completeParam = request.param(name: "complete"), let isComplete = Bool(completeParam), isComplete {
                        interaction.greeting?.creator = UserQuery.readByGreetingId(interaction.greeting?.id ?? 0)
                    }
                    let interactionData = try encoder.encode(interaction)
                    let interactionDataString = String(data: interactionData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: interactionDataString)
                    response.completed()
                } catch {
                    ErrorsManager.returnError(log: "Erro while encoding interaction: \(error).", message: "Internal server error.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Interaction not found.", message: "Interaction not found.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
        }
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let interactionParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(interactionParam) {
                if let interactionId = jsonObject["id"] as? Int, let isRetributed = jsonObject["is_retributed"] as? Bool, let isLikedBySender = jsonObject["is_liked_by_sender"] as? Bool, let isLikedByReceiver = jsonObject["is_liked_by_receiver"] as? Bool {
                    do {
                        let interaction: Interaction = Interaction()
                        interaction.id = interactionId
                        interaction.isRetributed = isRetributed
                        interaction.isLikedBySender = isLikedBySender
                        interaction.isLikedByReceiver = isLikedByReceiver
                        if let updatedInteraction = InteractionQuery.update(interaction) {
                            let updatedInteractionData = try encoder.encode(updatedInteraction)
                            let updatedInteractionString = String(data: updatedInteractionData, encoding: .utf8) ?? "{}"
                            response.appendBody(string: updatedInteractionString)
                            response.completed()
                        } else {
                            ErrorsManager.returnError(log: "Erro while updating interaction.", message: "Erro while updating interaction.", response: response)
                        }
                    } catch let encodingError as EncodingError {
                        ErrorsManager.returnError(log: "Error while encoding interaction: \(encodingError).", message: "Internal server error.", response: response)
                    } catch {
                        ErrorsManager.returnError(log: "Codable error while updating interaction: \(error).", message: "Internal server error.", response: response)
                    }
                } else {
                    ErrorsManager.returnError(log: "Argument missing.", message: "Argument missing", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing interaction data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func like(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let interactionParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(interactionParam) {
                if let interactionId = jsonObject["id_interaction"] as? Int, let userId = jsonObject["id_user"] as? Int {
                    do {
                        if let updatedInteraction = InteractionQuery.like(interactionId: interactionId, userId: userId) {
                            let updatedInteractionData = try encoder.encode(updatedInteraction)
                            let updatedInteractionString = String(data: updatedInteractionData, encoding: .utf8) ?? "{}"
                            response.appendBody(string: updatedInteractionString)
                            response.completed()
                        } else {
                            ErrorsManager.returnError(log: "Erro while updating interaction.", message: "Erro while updating interaction.", response: response)
                        }
                    } catch let encodingError as EncodingError {
                        ErrorsManager.returnError(log: "Error while encoding interaction: \(encodingError).", message: "Internal server error.", response: response)
                    } catch {
                        ErrorsManager.returnError(log: "Codable error while updating interaction: \(error).", message: "Internal server error.", response: response)
                    }
                } else {
                    ErrorsManager.returnError(log: "Argument missing.", message: "Argument missing", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing interaction data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func delete(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let interactionId = request.urlVariables["id"] {
            if let interactionIdAsInt = Int(interactionId){
                if let deletedInteraction = InteractionQuery.delete(interactionIdAsInt){
                    do {
                        let deletedInteractionData = try encoder.encode(deletedInteraction)
                        let deletedInteractionString = String(data: deletedInteractionData, encoding: .utf8) ?? "{}"
                        response.appendBody(string: deletedInteractionString)
                        response.completed()
                    } catch {
                        ErrorsManager.returnError(log: "Erro while encoding interaction: \(error).", message: "Internal server error.", response: response)
                    }
                }else{
                    ErrorsManager.returnError(log: "Error while deleting interaction by id.", message: "Error while deleting interaction by id.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Missing id argument.", message: "Missing id argument.", response: response)
        }
    }
}
