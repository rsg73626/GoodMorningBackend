import StORM
import PostgresStORM

class Contact: PostgresStORM, Codable{
    
    //MARK: Properties
    var id: Int? = 0
    var content: String!
    var type: ContactType!
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case Content = "content"
        case ContactType = "type"
    }
    
    //MARK: Initializers
    override init(){
        self.id = nil
        self.content = ""
        self.type = ContactType.Other
        super.init()
    }
    
    init(content: String, type: ContactType) {
        self.id = nil
        self.content = content
        self.type = type
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do { self.id = try values.decode(Int.self, forKey: .Id) } catch { self.id = nil }
        self.content = try values.decode(String.self, forKey: .Content)
        let type = try values.decode(Int.self, forKey: .ContactType)
        self.type = type == 1 ? ContactType.Cellphone : type == 2 ? ContactType.SocialNetwork : ContactType.Other
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.content, forKey: .Content)
        try container.encode(self.type?.rawValue, forKey: .ContactType)
    }
    
    //MARK: PostgresStORM
    override open func table() -> String { return ContactTable.tableName }
    
    override func to(_ this: StORMRow) {
        let contactType: Int = this.data[ContactTable.type] as? Int ?? 3
        id = this.data[ContactTable.id] as? Int ?? 0
        content = this.data[ContactTable.content] as? String ?? ""
        type = contactType == 1 ? ContactType.Cellphone : contactType == 2 ? ContactType.SocialNetwork : ContactType.Other
    }
    
    func rows() -> [Contact] {
        var rows = [Contact]()
        for i in 0..<self.results.rows.count {
            let row = Contact()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}

