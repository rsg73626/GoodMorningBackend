import PerfectHTTP

class ContactRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/", handler: ContactHandler.create)
        routes.add(method: .get, uri: "/", handler: ContactHandler.read)
        routes.add(method: .get, uri: "/{id}/", handler: ContactHandler.readById)
        routes.add(method: .put, uri: "/", handler: ContactHandler.update)
        routes.add(method: .delete, uri: "/{id}/", handler: ContactHandler.delete)
        
        return routes
    }
    
}

