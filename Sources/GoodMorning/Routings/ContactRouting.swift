import PerfectHTTP

class ContactRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/contact", handler: ContactHandler.create)
        routes.add(method: .get, uri: "/contact", handler: ContactHandler.read)
        routes.add(method: .get, uri: "/contact/{id}", handler: ContactHandler.readById)
        routes.add(method: .put, uri: "/contact", handler: ContactHandler.update)
        routes.add(method: .delete, uri: "/contact/{id}", handler: ContactHandler.delete)
        
        return routes
    }
    
}

