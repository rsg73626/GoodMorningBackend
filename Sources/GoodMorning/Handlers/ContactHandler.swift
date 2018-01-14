import PerfectHTTP
import Foundation

class ContactHandler {
    
    static func create(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let contactParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(contactParam) {
                if let contactDictionary = jsonObject["contact"] as? [String:Any], let content = contactDictionary["content"] as? String, let type = contactDictionary["type"] as? Int,  let userId = jsonObject["id_user"] as? Int {
                    do {
                        let contactString = "{\"content\":\"\(content)\", \"type\":\(type) }"
                        let contactData = contactString.data(using: .utf8)!
                        let contactFromData = try decoder.decode(Contact.self, from: contactData)
                        if let createdContact = ContactQuery.create(contactFromData, userId: userId) {
                            do {
                                let createdContactData = try encoder.encode(createdContact)
                                let createdContactString = String(data: createdContactData, encoding: .utf8) ?? "{}"
                                response.appendBody(string: createdContactString)
                                response.completed()
                            } catch {
                                ErrorsManager.returnError(log: "Error while encoding contact: \(error).", message: "Internal server error.", response: response)
                            }
                        } else {
                            ErrorsManager.returnError(log: "Error while creating contact.", message: "Error while creating contact.", response: response)
                        }
                    } catch {
                        ErrorsManager.returnError(log: "Error while encoding contact: \(error).", message: "Wrong format in request body content.", response: response)
                    }
                } else {
                    ErrorsManager.returnError(log: "Argument missing.", message: "Argument missing", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing contact data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func read(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            let contacts = ContactQuery.read()
            let contactsData = try encoder.encode(contacts)
            let contactsDataString = String(data: contactsData, encoding: .utf8) ?? "{}"
            response.appendBody(string: contactsDataString)
            response.completed()
        } catch {
            ErrorsManager.returnError(log: "Erro while encoding contacts: \(error).", message: "Internal server error.", response: response)
        }
    }
    
    static func readById(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let contactId = request.urlVariables["id"], let contactIdAsInt = Int(contactId) {
            if let contact = ContactQuery.readById(contactIdAsInt){
                do {
                    let contactData = try encoder.encode(contact)
                    let contactDataString = String(data: contactData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: contactDataString)
                    response.completed()
                } catch {
                    ErrorsManager.returnError(log: "Erro while encoding contact: \(error).", message: "Internal server error.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Contact not found.", message: "Contact not found.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
        }
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let contactParam = request.postBodyString {
            do {
                let contactData = contactParam.data(using: .utf8)
                let contactFromData = try decoder.decode(Contact.self, from: contactData!)
                if let updatedContact = ContactQuery.update(contactFromData) {
                    let updatedContactData = try encoder.encode(updatedContact)
                    let updatedContactString = String(data: updatedContactData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: updatedContactString)
                    response.completed()
                } else {
                    ErrorsManager.returnError(log: "Erro while updating contact.", message: "Erro while updating contact.", response: response)
                }
            } catch let decodingError as DecodingError {
                ErrorsManager.returnError(log: "Error while decoding user: \(decodingError).", message: "Wrong format in request body content.", response: response)
            } catch let encodingError as EncodingError {
                ErrorsManager.returnError(log: "Error while encoding user: \(encodingError).", message: "Internal server error.", response: response)
            } catch {
                ErrorsManager.returnError(log: "Codable error while updating user: \(error).", message: "Internal server error.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func delete(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let contactId = request.urlVariables["id"] {
            if let contactIdAsInt = Int(contactId){
                if let deletedContact = ContactQuery.delete(contactIdAsInt){
                    do {
                        let deletedContactData = try encoder.encode(deletedContact)
                        let deletedContactString = String(data: deletedContactData, encoding: .utf8) ?? "{}"
                        response.appendBody(string: deletedContactString)
                        response.completed()
                    } catch {
                        ErrorsManager.returnError(log: "Erro while encoding contact: \(error).", message: "Internal server error.", response: response)
                    }
                }else{
                    ErrorsManager.returnError(log: "Error while deleting contact by id.", message: "Error while deleting contact by id.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Missing id argument.", message: "Missing id argument.", response: response)
        }
    }
    
}
