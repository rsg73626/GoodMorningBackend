import PerfectHTTP

class ConfigRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes(baseUri: "/api")
        
        //MARK: User routing
        routes.add(UserRouting.makeURLRoutes())
        
        //MARK: Contact routingadd
        routes.add(ContactRouting.makeURLRoutes())
        
        //MARK: Greeting routingadd
        routes.add(GreetingRouting.makeURLRoutes())
        
        //MARK: Interaction routingadd
        routes.add(InteractionRouting.makeURLRoutes())
        
        return routes
    }
    
}

