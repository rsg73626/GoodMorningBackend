
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
var indexRout = Routes()
indexRout.add(method: .get, uri: "/", handler: {request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello World</title><body> Renan Soares Germano </body></html>")
    response.completed()
})
let routes = ConfigRouting.makeURLRoutes()
server.addRoutes(indexRout)
server.addRoutes(routes)

do {
    // Launch the HTTP server
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

