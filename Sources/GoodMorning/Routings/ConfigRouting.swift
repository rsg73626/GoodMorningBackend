import PerfectHTTP

class ConfigRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes(baseUri: "/api")
        
        //MARK: User routing
        routes.add(UserRouting.makeURLRoutes())
        
        //MARK: Contact routing
        routes.add(ContactRouting.makeURLRoutes())
        
        //MARK: Greeting routingadd
        routes.add(GreetingRouting.makeURLRoutes())
        
        //MARK: Greeting preference routing
        routes.add(GreetingPreferenceRouting.makeURLRoutes())
        
        //MARK: Interaction routing
        routes.add(InteractionRouting.makeURLRoutes())
        
        return routes
    }
    
}

