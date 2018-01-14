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
                if let createdUser = UserQuery.create(userFromData) {
                    do {
                        let createdUserData = try encoder.encode(createdUser)
                        let createdUserString = String(data: createdUserData, encoding: .utf8) ?? "{}"
                        response.appendBody(string: createdUserString)
                        response.completed()
                    } catch {
                        print("Error while encoding user: \(error).")
                        response.appendBody(string: "{\"error\":\"Internal server error.\"}")
                        response.completed()
                    }
                } else {
                    print("Error while creating user.")
                    response.appendBody(string: "{\"error\":\"Error while creating user.\"}")
                    response.completed()
                }
            } catch {
                print("Error while encoding user: \(error).")
                response.appendBody(string: "{\"error\":\"Wrong format in request body content.\"}")
                response.completed()
            }
        }else{
            print("Missing request body content.")
            response.appendBody(string: "{\"error\":\"Missing request body content.\"}")
            response.completed()
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
            print("Erro while encoding users: \(error).")
            response.appendBody(string: "{\"error\":\"Internal server error.\"}")
            response.completed()
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
                    print("Erro while encoding user: \(error).")
                    response.appendBody(string: "{\"error\":\"Internal server error.\"}")
                    response.completed()
                }
            }else{
                response.appendBody(string: "{\"error\":\"User not found.\"}")
                response.completed()
            }
        }else{
            response.appendBody(string: "{\"error\":\"Invalid id argument.\"}")
            response.completed()
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
                    print("Erro while updating user.")
                    response.appendBody(string: "{\"error\":\"Error while updating user.\"}")
                    response.completed()
                }
            } catch let decodingError as DecodingError {
                print("Error while decoding user: \(decodingError).")
                response.appendBody(string: "{\"error\":\"Wrong format in request body content.\"}")
                response.completed()
            } catch let encodingError as EncodingError {
                print("Error while encoding user: \(encodingError).")
                response.appendBody(string: "{\"error\":\"Internal server error.\"}")
                response.completed()
            } catch {
                print("Codable error while updating user: \(error).")
                response.appendBody(string: "{\"error\":\"Internal server error.\"}")
                response.completed()
            }
        }else{
            print("Missing request body content.")
            response.appendBody(string: "{\"error\":\"Missing request body content.\"}")
            response.completed()
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
                        print("Erro while encoding user: \(error).")
                        response.appendBody(string: "{\"error\":\"Internal server error.\"}")
                        response.completed()
                    }
                }else{
                    print("Error while deleting user by id.")
                    response.appendBody(string: "{\"error\":\"Error while deleting user by id.\"}")
                    response.completed()
                }
            }else{
                response.appendBody(string: "{\"error\":\"Invalid id argument.\"}")
                response.completed()
            }
        }else{
            response.appendBody(string: "{\"error\":\"Missing id argument.\"}")
            response.completed()
        }
    }
    
}
