import PerfectHTTP

class InteractionRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/", handler: InteractionHandler.create)
        routes.add(method: .get, uri: "/", handler: InteractionHandler.read)
        routes.add(method: .get, uri: "/{id}/", handler: InteractionHandler.readById)
        routes.add(method: .put, uri: "/", handler: InteractionHandler.update)
        routes.add(method: .put, uri: "/like/", handler: InteractionHandler.like)
        routes.add(method: .delete, uri: "/{id}/", handler: InteractionHandler.delete)
        
        return routes
    }
    
}


