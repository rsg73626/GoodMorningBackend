import PerfectHTTP
import Foundation

class UserHandler{
    
    static func create(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let userParam = request.param(name: "user"), let passwordParam = request.param(name: "password") {
            do {
                let userData = userParam.data(using: .utf8)!
                let userFromData = try decoder.decode(User.self, from: userData)
                if let createdUser = UserQuery.create(userFromData, password: passwordParam) {
                    let createdUserData = try encoder.encode(createdUser)
                    let createdUserString = String(data: createdUserData, encoding: .utf8)
                    response.appendBody(string: createdUserString ?? "{}")
                    response.completed()
                } else {
                    response.appendBody(string: "{\"error\":\"Error while creating user.\"}")
                    response.completed()
                }
            } catch {
                response.appendBody(string: "{\"error\":\"Error while encoding user: \(error).\"}")
                response.completed()
            }
        }else{
            response.appendBody(string: "{\"error\":\"Not enough arguments.\"}")
            response.completed()
        }
    }
    
    static func read(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        
        let encoder: JSONEncoder = JSONEncoder()
        let users = UserQuery.read()
        var data: Data!
        
        do {
            data = try encoder.encode(users)
        } catch {
            response.appendBody(string: "{\"error\":\"Erro while encoding users: \(error).\"}")
            response.completed()
        }
        
        let jsonDataString = String.init(data: data, encoding: .utf8)!
        response.appendBody(string: jsonDataString)
        response.completed()
    }
    
    static func readById(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        
        let encoder: JSONEncoder = JSONEncoder()
        
        if let userId = request.urlVariables["id"] {
            if let userIdAsInt = Int(userId){
                if let user = UserQuery.readById(userIdAsInt){
                    var data: Data!
                    do {
                        data = try encoder.encode(user)
                    } catch {
                        response.appendBody(string: "{\"error\":\"Erro while encoding user: \(error).\"}")
                        response.completed()
                    }
                    let jsonDataString = String.init(data: data, encoding: .utf8) ?? "{}"
                    response.appendBody(string: jsonDataString)
                    response.completed()
                }else{
                    response.appendBody(string: "{\"error\":\"Erro while reading user by id.\"}")
                    response.completed()
                }
            }else{
                response.appendBody(string: "{\"error\":\"Invalid id argument.\"}")
                response.completed()
            }
        }else{
            response.appendBody(string: "{\"error\":\"Not enough arguments.\"}")
            response.completed()
        }
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        
        if let userParam = request.postBodyString, let userId = request.urlVariables["id"] {
            if let userIdAsInt: Int = Int(userId) {
                do {
                    let userData = userParam.data(using: .utf8)!
                    let userFromData = try decoder.decode(User.self, from: userData)
                    if let updatedUser = UserQuery.update(userIdAsInt, newUser: userFromData) {
                        let updatedUserData = try encoder.encode(updatedUser)
                        let updatedUserString = String(data: updatedUserData, encoding: .utf8)
                        response.appendBody(string: updatedUserString ?? "{}")
                        response.completed()
                    } else {
                        print("erro1")
                        response.appendBody(string: "{\"error\":\"Error while updating user.\"}")
                        response.completed()
                    }
                } catch {
                    print("erro2")
                    response.appendBody(string: "{\"error\":\"Error while encoding user: \(error).\"}")
                    response.completed()
                }
            }else{
                print("erro3")
                response.appendBody(string: "{\"error\":\"Invalid id argument.\"}")
                response.completed()
            }
        }else{
            print("erro4")
            response.appendBody(string: "{\"error\":\"Argument missing.\"}")
            response.completed()
        }
    }
    
    static func delete(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        
        let encoder: JSONEncoder = JSONEncoder()
        
        if let userId = request.urlVariables["id"] {
            if let userIdAsInt = Int(userId){
                if let user = UserQuery.delete(userIdAsInt){
                    var data: Data!
                    do {
                        data = try encoder.encode(user)
                    } catch {
                        response.appendBody(string: "{\"error\":\"Erro while encoding user: \(error).\"}")
                        response.completed()
                    }
                    let jsonDataString = String.init(data: data, encoding: .utf8) ?? "{}"
                    response.appendBody(string: jsonDataString)
                    response.completed()
                }else{
                    response.appendBody(string: "{\"error\":\"Erro deleting reading user by id.\"}")
                    response.completed()
                }
            }else{
                response.appendBody(string: "{\"error\":\"Invalid id argument.\"}")
                response.completed()
            }
        }else{
            response.appendBody(string: "{\"error\":\"Not enough arguments.\"}")
            response.completed()
        }
    }
    
}
