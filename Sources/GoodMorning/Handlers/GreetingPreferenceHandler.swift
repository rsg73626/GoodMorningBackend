import PerfectHTTP
import Foundation

class GreetingPreferenceHandler {
    
    static func readById(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let greetingPreferenceId = request.urlVariables["id"], let greetingPreferenceIdAsInt = Int(greetingPreferenceId) {
            if let greetingPreference = GreetingPreferenceQuery.readById(greetingPreferenceIdAsInt){
                do {
                    let greetingPreferenceData = try encoder.encode(greetingPreference)
                    let greetingPreferenceDataString = String(data: greetingPreferenceData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: greetingPreferenceDataString)
                    response.completed()
                } catch {
                    ErrorsManager.returnError(log: "Erro while encoding greeting preference: \(error).", message: "Internal server error.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Greeting preference not found.", message: "Greeting preference not found.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
        }
    }
    
    static func readByUserId (request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let userId = request.urlVariables["id"], let userIdAsInt = Int(userId) {
            do {
                let greetingPreferences = GreetingPreferenceQuery.readByUserId(userIdAsInt)
                let greetingPreferencesData = try encoder.encode(greetingPreferences)
                let greetingPreferencesDataString = String(data: greetingPreferencesData, encoding: .utf8) ?? "{}"
                response.appendBody(string: greetingPreferencesDataString)
                response.completed()
            } catch {
                ErrorsManager.returnError(log: "Erro while encoding greeting preferences: \(error).", message: "Internal server error.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
        }
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let greetingPreferenceParam = request.postBodyString {
            do {
                let greetingPreferenceData = greetingPreferenceParam.data(using: .utf8)
                let greetingPreferenceFromData = try decoder.decode(GreetingPreference.self, from: greetingPreferenceData!)
                if let updatedGreetingPreference = GreetingPreferenceQuery.update(greetingPreferenceFromData) {
                    let updatedGreetingPreferenceData = try encoder.encode(updatedGreetingPreference)
                    let updatedGreetingPreferenceString = String(data: updatedGreetingPreferenceData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: updatedGreetingPreferenceString)
                    response.completed()
                } else {
                    ErrorsManager.returnError(log: "Erro while updating greeting preference.", message: "Erro while updating greeting preference.", response: response)
                }
            } catch let decodingError as DecodingError {
                ErrorsManager.returnError(log: "Error while decoding greeting preference: \(decodingError).", message: "Wrong format in request body content.", response: response)
            } catch let encodingError as EncodingError {
                ErrorsManager.returnError(log: "Error while encoding greeting preference: \(encodingError).", message: "Internal server error.", response: response)
            } catch {
                ErrorsManager.returnError(log: "Codable error while updating greeting preference: \(error).", message: "Internal server error.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
}
