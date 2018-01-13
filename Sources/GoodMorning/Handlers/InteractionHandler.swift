import PerfectHTTP

class InteractionHandler{
    
    static func create(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>INTERACTION</title><body>CREATE!</body></html>")
        response.completed()
    }
    
    static func read(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>INTERACTION</title><body>READ!</body></html>")
        response.completed()
    }
    
    static func readById(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>INTERACTION</title><body>READ BY ID!</body></html>")
        response.completed()
    }
    
    static func update(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>INTERACTION</title><body>UPDATE!</body></html>")
        response.completed()
    }
    
    static func delete(request: HTTPRequest, response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>INTERACTION</title><body>DELETE!</body></html>")
        response.completed()
    }
    
}
