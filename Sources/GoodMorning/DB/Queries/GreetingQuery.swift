import StORM
import PostgresStORM

class GreetingQuery {
    
    static func create(_ greeting: Greeting) -> Greeting? {
        return nil
    }
    
    static func read() -> [Greeting] {
        var greetings = [Greeting]()
        
        return greetings
    }
    
    static func readById(_ id: Int) -> Greeting? {
        return nil
    }
    
    static func update(_: Greeting) -> Greeting? {
        return nil
    }
    
    static func delete(_ id: Int) -> Greeting? {
        return nil
    }
    
}

