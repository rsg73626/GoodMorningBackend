import StORM
import PostgresStORM

class User: PostgresStORM, Codable{
    
    //MARK: Properties
    var id: Int = 0
    var name: String?
    var email: String?
    var photo: String?
    var about: String?
    var contacts: [Contact] = [Contact]()
    
    //MARK: Initializers
    override init(){
        self.name = nil
        self.email = nil
        self.photo = nil
        self.about = nil
        super.init()
    }
    
    init(name: String, email: String, photo: String, about: String) {
        self.name = name
        self.email = email
        self.photo = photo
        self.about = about
    }
    
    init(name: String, email: String, photo: String, about: String, contacts: [Contact]) {
        self.name = name
        self.email = email
        self.photo = photo
        self.about = about
        self.contacts = contacts
    }
    
    //MARK: PostgresStORM
    override open func table() -> String { return "goodmorning_user" }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        email = this.data["email"] as? String ?? ""
        photo = this.data["photo"] as? String ?? ""
        about = this.data["about"] as? String ?? ""
        contacts = ContactQuery.readByUserId(id)
    }
    
    func rows() -> [User] {
        var rows = [User]()
        for i in 0..<self.results.rows.count {
            let row = User()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

