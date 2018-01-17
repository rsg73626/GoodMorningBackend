import PerfectHTTP

class ConfigRouting{
    
    static func makeURLRoutes() -> Routes{
        
        var routes: Routes = Routes(baseUri: "/api")
        
        //MARK: User routing
        var userRoutes: Routes = Routes(baseUri: "/user")
        userRoutes.add(UserRouting.makeURLRoutes())
        routes.add(userRoutes)
        
        //MARK: Contact routingadd
        var contactRoutes: Routes = Routes(baseUri: "/contact")
        contactRoutes.add(ContactRouting.makeURLRoutes())
        routes.add(contactRoutes)
        
        //MARK: Greeting routingadd
        var greetingRoutes: Routes = Routes(baseUri: "/greeting")
        greetingRoutes.add(GreetingRouting.makeURLRoutes())
        routes.add(greetingRoutes)
        
        //MARK: Interaction routingadd
        var interactionRoutes: Routes = Routes(baseUri: "/interaction")
        interactionRoutes.add(InteractionRouting.makeURLRoutes())
        routes.add(interactionRoutes)
        
        return routes
    }
    
}

