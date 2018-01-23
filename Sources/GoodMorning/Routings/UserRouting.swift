import PerfectHTTP

class UserRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .post, uri: "/user", handler: UserHandler.create)
        routes.add(method: .post, uri: "/user/login", handler: UserHandler.login)
        routes.add(method: .get, uri: "/user", handler: UserHandler.read)
        routes.add(method: .get, uri: "/user/{id}", handler: UserHandler.readById)
        routes.add(method: .put, uri: "/user", handler: UserHandler.update)
        routes.add(method: .delete, uri: "/user/{id}", handler: UserHandler.delete)
        
        return routes
    }
    
}


