import PerfectHTTP

class InteractionRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/interaction", handler: InteractionHandler.create)
        routes.add(method: .get, uri: "/interaction", handler: InteractionHandler.read)
        routes.add(method: .get, uri: "/interaction/{id}", handler: InteractionHandler.readById)
        routes.add(method: .put, uri: "/interaction", handler: InteractionHandler.update)
        routes.add(method: .put, uri: "/interaction/like", handler: InteractionHandler.like)
        routes.add(method: .delete, uri: "/interaction/{id}", handler: InteractionHandler.delete)
        
        return routes
    }
    
}


