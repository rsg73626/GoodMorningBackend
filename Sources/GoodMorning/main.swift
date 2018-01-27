
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create database
ConfigDB.connect(host: "localhost", username: "rsgermano1", password: "", database: "goodmorning", port: 5432)
ConfigDB.createTables()
ConfigDB.runSeeds()

// Create server object.
let server = HTTPServer()

// Listen on port 8181.
server.serverPort = 8181

// Add our routes.
let goodmorning: (HTTPRequest, HTTPResponse) -> Void = {request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Good Morning</title><body> Good Morning APP Server </body></html>")
    response.completed()
}
let api: (HTTPRequest, HTTPResponse) -> Void = {request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Good Morning API</title><body> Good Morning API Documentation <br/> <a href=\"https://documenter.getpostman.com/go?view=Y29sbGVjdGlvbl9pZD0yYjBkODE0MC04MjY4LTVmNGUtMmMxOS0yNTcwMmNmOGEzZmEmb3duZXI9MjA3OTU2MyZ1c2VyX2lkPTIwNzk1NjMmYWNjZXNzX3Rva2VuPTFjNTEwOTgwMmQ3ZjhlZDAxNTBmMjcwZGY4NWU0NTdjMWU5ZGFhZjYxYTE2Y2JkZjQ5NDhlNzQxM2VmMDA0YTUzMTEyYjAxNGRhODNkYzcwMmQxYzEwOWY5NjhjYTc2NzkxZDJjNTk4NGZhZmM2YTAzYjYzOThlYzNhNmViZDMyJnN5bmNfZW52PXByZW1pdW0mYXBwX2lkPWVyaXNlZHN0cmFlaHJ1b3l0dWJlY2FmcnVveXRvbndvaHNpJmFwcF92ZXJzaW9uPTUuMy4y\"> Documentation Link </a> </body></html>")
    response.completed()
}
var indexRout = Routes()
indexRout.add(method: .get, uris: ["","/", "/index", "/index/", "/index.html", "/index.html/"], handler: goodmorning)
indexRout.add(method: .get, uris: ["/api", "/api/"], handler: api)
let routes = ConfigRouting.makeURLRoutes()
server.addRoutes(indexRout)
server.addRoutes(routes)

do {
    // Launch the HTTP server
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

