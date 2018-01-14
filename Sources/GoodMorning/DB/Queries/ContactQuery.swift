import StORM
import PostgresStORM

class ContactQuery {
    
    static func create(_ contact: Contact, userId: Int) -> Contact? {
        let createObj: Contact = Contact()
        do {
            let res = try createObj.sql("insert into contact(content, id_contact_type, id_goodmorning_user) values($1, $2, $3) returning id", params: [contact.content, "\(contact.type!.rawValue)", "\(userId)"])
            let createdId: Int = res.getFieldInt(tupleIndex: 0, fieldIndex: 0) ?? 0
            return readById(createdId)
        } catch {
            print("Error while creating contact: \(error)")
            return nil
        }
    }
    
    static func read() -> [Contact] {
        var contacts = [Contact]()
        let getObj: Contact = Contact()
        do {
            try getObj.select(columns: ["id", "content", "id_contact_type"], whereclause: "", params: [], orderby: ["id"])
            contacts = getObj.rows()
        } catch {
            print("Error while reading contacts: \(error)")
        }
        return contacts
    }
    
    static func readById(_ id: Int) -> Contact? {
        let getObj: Contact = Contact()
        do {
            try getObj.select(columns: ["id", "content", "id_contact_type"], whereclause: "id = $1", params: [id], orderby: ["id"])
            let contacts = getObj.rows()
            return contacts.first
        } catch {
            print("Error while reading contact by id: \(error)")
            return nil
        }
    }
    
    static func readByUserId(_ id: Int) -> [Contact] {
        var contacts = [Contact]()
        let getObj: Contact = Contact()
        do {
            try getObj.select(columns: ["id", "content", "id_contact_type"], whereclause: "id_goodmorning_user = $1", params: [id], orderby: ["id"])
            contacts = getObj.rows()
        } catch {
            print("Error while reading contacts by user id: \(error)")
        }
        return contacts
    }
    
    static func update(_ contact: Contact) -> Contact? {
        let updateObj: Contact = Contact()
        do {
            let _ = try updateObj.sql("update contact set content = $1, id_contact_type = $2 where id = $3", params: [contact.content, "\(contact.type!.rawValue)", "\(contact.id!)"])
            return readById(contact.id!)
        } catch {
            print("Error while updating contact: \(error)")
            return nil
        }
    }
    
    static func delete(_ id: Int) -> Contact? {
        let deleteObj: Contact = Contact()
        let deletedContact = readById(id)
        do {
            let _ = try deleteObj.sql("delete from contact where id = $1", params: ["\(id)"])
            return deletedContact
        } catch {
            print("Error while deleting user: \(error)")
            return nil
        }
    }
    
}

