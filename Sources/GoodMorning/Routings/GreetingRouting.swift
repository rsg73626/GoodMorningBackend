import PerfectHTTP

class GreetingRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/greeting", handler: GreetingHandler.create)
        routes.add(method: .get, uri: "/greeting", handler: GreetingHandler.read)
        routes.add(method: .get, uri: "/greeting/{id}", handler: GreetingHandler.readById)
        routes.add(method: .put, uri: "/greeting", handler: GreetingHandler.update)
        routes.add(method: .delete, uri: "/greeting/{id}", handler: GreetingHandler.delete)
        
        return routes
    }
    
}


