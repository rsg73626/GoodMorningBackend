import PerfectHTTP

class UserRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/", handler: UserHandler.create)
        routes.add(method: .get, uri: "/", handler: UserHandler.read)
        routes.add(method: .get, uri: "/{id}/", handler: UserHandler.readById)
        routes.add(method: .put, uri: "/", handler: UserHandler.update)
        routes.add(method: .delete, uri: "/{id}/", handler: UserHandler.delete)
        
        return routes
    }
    
}


