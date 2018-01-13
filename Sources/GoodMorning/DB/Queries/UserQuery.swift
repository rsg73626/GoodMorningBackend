import StORM
import PostgresStORM

class UserQuery {
    
    static func create(_ user: User, password: String) -> User? {
        let createObj: User = User()
        do {
            let res = try createObj.sql("insert into goodmorning_user (name, about, photo, email, password) values($1, $2, $3, $4, $5) returning id", params: [user.name!, user.about!, user.photo!, user.email!, password])
            let createdId: Int = res.getFieldInt(tupleIndex: 0, fieldIndex: 0) ?? 0
            for contact in user.contacts {
                let createdContact = ContactQuery.create(contact, userId: createdId)
                contact.id = createdContact?.id ?? 0
            }
            return readById(createdId)
        } catch {
            print("Error while creating user: \(error)")
            return nil
        }
    }
    
    static func read() -> [User] {
        var users = [User]()
        let getObj: User = User()
        do {
            try getObj.select(columns: ["id", "name", "about", "photo", "email", "password"], whereclause: "", params: [], orderby: ["id"])
            users = getObj.rows()
        } catch {
            print("Error while reading users: \(error)")
        }
        return users
    }
    
    static func readById(_ id: Int) -> User? {
        let getObj: User = User()
        do {
            try getObj.select(columns: ["id", "name", "about", "photo", "email", "password"], whereclause: "id = $1", params: [id], orderby: ["id"])
            let users = getObj.rows()
            return users.first
        } catch {
            print("Error while reading user by id: \(error)")
            return nil
        }
    }
    
    static func update(_ id: Int, newUser: User) -> User? {
        let updateObj: User = User()
        do {
            let _ = try updateObj.sql("update goodmorning_user set name = $1, about = $2, photo = $3, email = $4 where id = $5", params: [newUser.name!, newUser.about!, newUser.photo!, newUser.email!, "\(id)"])
            return readById(id)
        } catch {
            print("Error while updating user: \(error)")
            return nil
        }
    }
    
    static func delete(_ id: Int) -> User? {
        let deleteObj: User = User()
        let deletedUser = readById(id)
        do {
            let _ = try deleteObj.sql("delete from goodmorning_user where id = $1", params: ["\(id)"])
            return deletedUser
        } catch {
            print("Error while updating user: \(error)")
            return nil
        }
        
    }
    
}
