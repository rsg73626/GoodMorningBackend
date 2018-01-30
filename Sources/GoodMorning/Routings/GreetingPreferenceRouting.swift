import PerfectHTTP

class GreetingPreferenceRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes()
        
        routes.add(method: .get, uri: "/greeting_preference/{id}", handler: GreetingPreferenceHandler.readById)
        routes.add(method: .get, uri: "/greeting_preference/user/{id}", handler: GreetingPreferenceHandler.readByUserId)
        routes.add(method: .put, uri: "/greeting_preference", handler: GreetingPreferenceHandler.update)
        
        return routes
    }
    
}
