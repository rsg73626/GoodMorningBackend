import PerfectHTTP
import Foundation

class UserHandler{
    
    static func create(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let userParam = request.postBodyString {
            do {
                let userData = userParam.data(using: .utf8)!
                let userFromData = try decoder.decode(User.self, from: userData)
                if let _ = userFromData.password {
                    if let _ = UserQuery.readByEmail(userFromData.email) {
                        ErrorsManager.returnError(log: "There's already an user with the informed email.", message: "There's already an user with the informed email.", response: response)
                    } else {
                        if let createdUser = UserQuery.create(userFromData) {
                            do {
                                let createdUserData = try encoder.encode(createdUser)
                                let createdUserString = String(data: createdUserData, encoding: .utf8) ?? "{}"
                                response.appendBody(string: createdUserString)
                                response.completed()
                            } catch {
                                ErrorsManager.returnError(log: "Error while encoding user: \(error).", message: "Internal server error.", response: response)
                            }
                        } else {
                            ErrorsManager.returnError(log: "Error while creating user.", message: "Error while creating user.", response: response)
                        }
                    }
                } else {
                    ErrorsManager.returnError(log: "User password missing.", message: "User password missing.", response: response)
                }
            } catch {
                ErrorsManager.returnError(log: "Error while encoding user: \(error).", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func read(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            let users = UserQuery.read()
            let usersData = try encoder.encode(users)
            let usersDataString = String(data: usersData, encoding: .utf8) ?? "{}"
            response.appendBody(string: usersDataString)
            response.completed()
        } catch {
            ErrorsManager.returnError(log: "Erro while encoding users: \(error).", message: "Internal server error.", response: response)
        }
    }
    
    static func readById(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let userId = request.urlVariables["id"], let userIdAsInt = Int(userId) {
            if let user = UserQuery.readById(userIdAsInt){
                do {
                    let userData = try encoder.encode(user)
                    let userDataString = String(data: userData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: userDataString)
                    response.completed()
                } catch {
                    ErrorsManager.returnError(log: "Erro while encoding user: \(error).", message: "Internal server error.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "User not found.", message: "User not found.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
        }
    }
    
    static func login(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let userDataParam = request.postBodyString {
            if let jsonObject = Parser.shared.jsonStringToDictionary(userDataParam) {
                if let email = jsonObject["email"] as? String, let password = jsonObject["password"] as? String {
                    if let user = UserQuery.readByEmailAndPassword(email: email, password: password) {
                        do {
                            let userData = try encoder.encode(user)
                            let userDataString = String(data: userData, encoding: .utf8) ?? "{}"
                            response.appendBody(string: userDataString)
                            response.completed()
                        } catch {
                            ErrorsManager.returnError(log: "Erro while encoding user: \(error).", message: "Internal server error.", response: response)
                        }
                    } else {
                        ErrorsManager.returnError(log: "Wrong user or password.", message: "Wrong user or password.", response: response)
                    }
                } else {
                    ErrorsManager.returnError(log: "Argument missing.", message: "Argument missing", response: response)
                }
            } else {
                ErrorsManager.returnError(log: "Error while parsing user data to dictionary.", message: "Wrong format in request body content.", response: response)
            }
        } else {
            ErrorsManager.returnError(log: "Missing request body content.", message: "Missing request body content.", response: response)
        }
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let userParam = request.postBodyString {
            do {
                let userData = userParam.data(using: .utf8)
                let userFromData = try decoder.decode(User.self, from: userData!)
                if let updatedUser = UserQuery.update(userFromData) {
                    let updatedUserData = try encoder.encode(updatedUser)
                    let updatedUserString = String(data: updatedUserData, encoding: .utf8) ?? "{}"
                    response.appendBody(string: updatedUserString)
                    response.completed()
                } else {
                    ErrorsManager.returnError(log: "Erro while updating user.", message: "Erro while updating user.", response: response)
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
    
    static func delete(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        
        if let userId = request.urlVariables["id"] {
            if let userIdAsInt = Int(userId){
                if let deletedUser = UserQuery.delete(userIdAsInt){
                    do {
                        let deletedUserData = try encoder.encode(deletedUser)
                        let deletedUserString = String(data: deletedUserData, encoding: .utf8) ?? "{}"
                        response.appendBody(string: deletedUserString)
                        response.completed()
                    } catch {
                        ErrorsManager.returnError(log: "Erro while encoding user: \(error).", message: "Internal server error.", response: response)
                    }
                }else{
                    ErrorsManager.returnError(log: "Error while deleting user by id.", message: "Error while deleting user by id.", response: response)
                }
            }else{
                ErrorsManager.returnError(log: "Invalid id argument.", message: "Invalid id argument.", response: response)
            }
        }else{
            ErrorsManager.returnError(log: "Missing id argument.", message: "Missing id argument.", response: response)
        }
    }
}
