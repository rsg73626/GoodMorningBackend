import PerfectHTTP

class GreetingRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/", handler: GreetingHandler.create)
        routes.add(method: .get, uri: "/", handler: GreetingHandler.read)
        routes.add(method: .get, uri: "/{id}/", handler: GreetingHandler.readById)
        routes.add(method: .put, uri: "/", handler: GreetingHandler.update)
        routes.add(method: .delete, uri: "/{id}/", handler: GreetingHandler.delete)
        
        return routes
    }
    
}


