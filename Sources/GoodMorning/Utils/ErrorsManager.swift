import PerfectHTTP
import Foundation

class ErrorsManager {
    
    static func returnError(log: String, message: String, response: HTTPResponse) {
        print(log)
        response.appendBody(string: "{\"error\":\"\(message)\"}")
        response.completed()
    }
    
}
