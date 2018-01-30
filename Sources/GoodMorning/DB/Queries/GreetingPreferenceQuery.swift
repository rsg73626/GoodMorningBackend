import StORM
import PostgresStORM

class GreetingPreferenceQuery {
    
    static func create(_ greetingPreference: GreetingPreference, userId: Int) -> GreetingPreference? {
        let createObject: GreetingPreference = GreetingPreference()
        do {
            let from = Parser.shared.dateToString(greetingPreference.from, format: "yyyy-MM-dd HH:mm")!
            let res = try createObject.sql("insert into \(GreetingPreferenceTable.tableName)(\(GreetingPreferenceTable.user), \(GreetingPreferenceTable.type), \(GreetingPreferenceTable.isActive), \(GreetingPreferenceTable.fromTime), \(GreetingPreferenceTable.fromString)) values($1, $2, $3, $4, $5) returning \(GreetingPreferenceTable.id)", params: ["\(userId)", "\(greetingPreference.type.rawValue)", "\(greetingPreference.isActive)", from, from])
            let createdId: Int = res.getFieldInt(tupleIndex: 0, fieldIndex: 0) ?? 0
            return readById(createdId)
        } catch {
            print("Error while creating greeting preference: \(error)")
            return nil
        }
    }
    
    static func readById(_ id: Int) -> GreetingPreference? {
        let getObj: GreetingPreference = GreetingPreference()
        do {
            try getObj.select(columns:[GreetingPreferenceTable.id,GreetingPreferenceTable.user,GreetingPreferenceTable.type,GreetingPreferenceTable.isActive,GreetingPreferenceTable.fromString],whereclause:"\(GreetingPreferenceTable.id)= $1",params:[id],orderby:[GreetingPreferenceTable.id])
            let greetingPreferences = getObj.rows()
            return greetingPreferences.first
        } catch {
            print("Error while reading greeting preference by id: \(error)")
            return nil
        }
    }
    
    static func readByUserId(_ id: Int) -> [GreetingPreference] {
        var greetingPreferences = [GreetingPreference]()
        let getObj: GreetingPreference = GreetingPreference()
        do {
            try getObj.select(columns:[GreetingPreferenceTable.id,GreetingPreferenceTable.user,GreetingPreferenceTable.type,GreetingPreferenceTable.isActive,GreetingPreferenceTable.fromString],whereclause:"\(GreetingPreferenceTable.user) = $1",params:[id],orderby:[GreetingPreferenceTable.id])
            greetingPreferences = getObj.rows()
        } catch {
            print("Error while reading greeting preferences by user id: \(error)")
        }
        return greetingPreferences
    }
    
    static func readByUserIdAndType(userId: Int, type: Int) -> GreetingPreference? {
        let getObj: GreetingPreference = GreetingPreference()
        do {
            try getObj.select(columns:[GreetingPreferenceTable.id,GreetingPreferenceTable.user,GreetingPreferenceTable.type,GreetingPreferenceTable.isActive,GreetingPreferenceTable.fromString],whereclause:"\(GreetingPreferenceTable.id)= $1 and \(GreetingPreferenceTable.type) = $2",params:[userId, type],orderby:[GreetingPreferenceTable.id])
            let greetingPreferences = getObj.rows()
            return greetingPreferences.first
        } catch {
            print("Error while reading greeting preference by user id and type: \(error)")
            return nil
        }
    }
    
    static func update(_ greetingPreference: GreetingPreference) -> GreetingPreference? {
        let updateObj: Greeting = Greeting()
        let from = Parser.shared.dateToString(greetingPreference.from, format: "yyyy-MM-dd HH:mm")!
        do {
            let query = "update \(GreetingPreferenceTable.tableName) set \(GreetingPreferenceTable.isActive) = $1, \(GreetingPreferenceTable.fromTime) = $2, \(GreetingPreferenceTable.fromString) = $3 where \(GreetingPreferenceTable.id) = $4"
            let _ = try updateObj.sql(query, params: ["\(greetingPreference.isActive)", from, from, "\(greetingPreference.id ?? 0)"])
            return readById(greetingPreference.id ?? 0)
        } catch {
            print("Error while updating greeting preference: \(error)")
            return nil
        }
    }
}
