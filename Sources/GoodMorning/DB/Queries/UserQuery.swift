import StORM
import PostgresStORM

class UserQuery {
    
    static func create(_ user: User) -> User? {
        let createObj: User = User()
        
        var photo: String = ""
        var about: String = ""
        var contacts: [Contact] = [Contact]()
        
        if let userPhoto = user.photo { photo = userPhoto }
        if let userAbout = user.about { about = userAbout }
        if let userContacts = user.contacts { contacts = userContacts }
        
        do {
            let query = "insert into goodmorning_user (name, email, password, photo, about) values($1, $2, $3, $4, $5) returning id"
            let res = try createObj.sql(query, params: [user.name, user.email, user.password!, photo, about])
            let createdId: Int = res.getFieldInt(tupleIndex: 0, fieldIndex: 0) ?? 0
            contacts.forEach {contact in let _ = ContactQuery.create(contact, userId: createdId)}
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
            
            users.forEach {user in user.contacts = ContactQuery.readByUserId(user.id!)}
            
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
    
    static func readByEmail(_ email: String) -> User? {
        let getObj: User = User()
        do {
            try getObj.select(columns: ["id", "name", "about", "photo", "email", "password"], whereclause: "email = $1", params: [email], orderby: ["id"])
            let users = getObj.rows()
            return users.first
        } catch {
            print("Error while reading user by id: \(error)")
            return nil
        }
    }
    
    static func readByEmailAndPassword (email: String, password: String) -> User? {
        let getObj: User = User()
        do {
            try getObj.select(columns: ["id", "name", "about", "photo", "email", "password"], whereclause: "email = $1 and password = $2", params: [email, password], orderby: ["id"])
            let users = getObj.rows()
            return users.first
        } catch {
            print("Error while reading user by id: \(error)")
            return nil
        }
    }
    
    static func update(_ newUser: User) -> User? {
        let updateObj: User = User()
        
        var photo: String = ""
        var about: String = ""
        
        if let userPhoto = newUser.photo { photo = userPhoto }
        if let userAbout = newUser.about { about = userAbout }
        
        do {
            let query = "update goodmorning_user set name = $1, about = $2, photo = $3, email = $4 where id = $5"
            let _ = try updateObj.sql(query, params: [newUser.name, about, photo, newUser.email!, "\(newUser.id!)"])
            return readById(newUser.id!)
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
            print("Error while deleting user: \(error)")
            return nil
        }
    }
    
}
