import StORM
import PostgresStORM

class GreetingQuery {
    
    static func create(_ greeting: Greeting, userId: Int) -> Greeting? {
        let createObj: Greeting = Greeting()
        do {
            let creation = Parser.shared.dateToString(greeting.date, format: "yyyy-MM-dd")!
            let res = try createObj.sql("insert into \(GreetingTable.tableName)(\(GreetingTable.type), \(GreetingTable.message), \(GreetingTable.creationDate), \(GreetingTable.creationString), \(GreetingTable.creator)) values($1, $2, $3, $4, $5) returning \(GreetingTable.id)", params: ["\(greeting.type.rawValue)", greeting.message,creation, creation , "\(userId)"])
            let createdId: Int = res.getFieldInt(tupleIndex: 0, fieldIndex: 0) ?? 0
            return readById(createdId)
        } catch {
            print("Error while creating greeting: \(error)")
            return nil
        }
    }
    
    static func read() -> [Greeting] {
        var greetings = [Greeting]()
        let getObj: Greeting = Greeting()
        do {
            try getObj.select(columns: [GreetingTable.id, GreetingTable.type, GreetingTable.message, GreetingTable.creationString], whereclause: "", params: [], orderby: [GreetingTable.id])
            greetings = getObj.rows()
        } catch {
            print("Error while reading greetings: \(error)")
        }
        return greetings
    }
    
    static func readById(_ id: Int) -> Greeting? {
        let getObj: Greeting = Greeting()
        do {
            try getObj.select(columns: [GreetingTable.id, GreetingTable.type, GreetingTable.message, GreetingTable.creationString], whereclause: "\(GreetingTable.id) = $1", params: [id], orderby: [GreetingTable.id])
            let greetings = getObj.rows()
            return greetings.first
        } catch {
            print("Error while reading greeting by id: \(error)")
            return nil
        }

    }
    
    static func update(greetingId: Int, newMessage: String) -> Greeting? {
        let updateObj: Greeting = Greeting()
        do {
            let _ = try updateObj.sql("update \(GreetingTable.tableName) set \(GreetingTable.message) = $1 where \(GreetingTable.id) = $2", params: [newMessage, "\(greetingId)"])
            return readById(greetingId)
        } catch {
            print("Error while updating greeting: \(error)")
            return nil
        }
    }
    
    static func delete(_ id: Int) -> Greeting? {
        let deleteObj: Greeting = Greeting()
        let deletedGreeting = readById(id)
        do {
            let _ = try deleteObj.sql("delete from \(GreetingTable.tableName) where \(GreetingTable.id) = $1", params: ["\(id)"])
            return deletedGreeting
        } catch {
            print("Error while deleting greeting: \(error)")
            return nil
        }
    }
    
}

