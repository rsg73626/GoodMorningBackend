import StORM
import PostgresStORM

class User: PostgresStORM, Codable{
    
    //MARK: Properties
    var id: Int? = 0
    var name: String!
    var email: String!
    var password: String?
    var photo: String?
    var about: String?
    var contacts: [Contact]?
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case Name = "name"
        case Email = "email"
        case Password = "password"
        case Photo = "photo"
        case About = "about"
        case Contacts = "contacts"
    }
    
    
    //MARK: Initializers
    override init(){
        self.name = ""
        self.email = ""
        self.password = nil
        self.photo = nil
        self.about = nil
        super.init()
    }
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    init(name: String, email: String, password: String, photo: String, about: String, contacts: [Contact]) {
        self.name = name
        self.email = email
        self.password = password
        self.photo = photo
        self.about = about
        self.contacts = contacts
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do { self.id = try values.decode(Int.self, forKey: .Id) } catch { self.id = nil }
        self.name = try values.decode(String.self, forKey: .Name)
        self.email = try values.decode(String.self, forKey: .Email)
        do { self.password = try values.decode(String.self, forKey: .Password) } catch { self.password = nil }
        do { self.photo = try values.decode(String.self, forKey: .Photo) } catch { self.photo = nil }
        do { self.about = try values.decode(String.self, forKey: .About) } catch { self.about = nil }
        do { self.contacts = try values.decode([Contact].self, forKey: .Contacts) } catch { self.contacts = [Contact]() }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.name, forKey: .Name)
        try container.encode(self.email, forKey: .Email)
        try container.encode(self.photo, forKey: .Photo)
        try container.encode(self.about, forKey: .About)
        try container.encode(self.contacts, forKey: .Contacts)
    }

    
    //MARK: PostgresStORM
    override open func table() -> String { return "goodmorning_user" }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as! String
        email = this.data["email"] as! String
        photo = this.data["photo"] as? String ?? ""
        about = this.data["about"] as? String ?? ""
        contacts = ContactQuery.readByUserId(id!)
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

