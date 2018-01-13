import StORM
import PostgresStORM
import Foundation

class Greeting: PostgresStORM, Codable{
    
    //MARK: Properties
    var id: Int = 0
    var type: GreetingType?
    var message: String?
    var date: Date?
    var user: User?
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case GreetingType = "type"
        case Message = "message"
        case Date = "date"
        case User  = "user"
    }
    
    //MARK: Initializers
    override init(){
        self.type = nil
        self.message = nil
        self.date = nil
        self.user = nil
        super.init()
    }
    
    init(type: GreetingType, message: String, date: Date?, user: User) {
        self.type = type
        self.message = message
        self.date = date
        self.user = user
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .Id)
        let type = try values.decode(Int.self, forKey: .GreetingType)
        self.type = type == 1 ? GreetingType.GoodMorning : type == 2 ? GreetingType.GoodAfternoon : type == 3 ? GreetingType.GoodEvening : GreetingType.GoodDawn
        self.message = try values.decode(String.self, forKey: .Message)
        let date = try values.decode(String.self, forKey: .Date)
        self.date = Parser.shared.stringToDate(date, format: "dd/MM/yyyy")
        self.user = try values.decode(User.self, forKey: .User)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.type?.rawValue, forKey: .GreetingType)
        try container.encode(self.message, forKey: .Message)
        try container.encode(Parser.shared.dateToString(self.date!, format: "dd/MM/yyyy"), forKey: .Date)
        try container.encode(self.user, forKey: .User)
    }
    
    //MARK: PostgresStORM
    override open func table() -> String { return "greeting" }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        let greetingType: Int = this.data["id_greeting_type"] as? Int ?? 4
        type = greetingType == 1 ? GreetingType.GoodMorning : greetingType == 2 ? GreetingType.GoodAfternoon : greetingType == 3 ? GreetingType.GoodEvening : GreetingType.GoodDawn
        let stringDate: String = this.data["creation"] as? String ?? "1970-01-01"
        date = Parser.shared.stringToDate(stringDate, format: "yyyy-MM-dd")
        let userId: Int = this.data["id_goodmorning_user"] as? Int ?? 0
        user = UserQuery.readById(userId)
        //        id                = this.data["id"] as? Int                ?? 0
        //        firstname        = this.data["firstname"] as? String        ?? ""
        //        lastname        = this.data["lastname"] as? String        ?? ""
        //        email            = this.data["email"] as? String            ?? ""
    }
    
    func rows() -> [Greeting] {
        var rows = [Greeting]()
        for i in 0..<self.results.rows.count {
            let row = Greeting()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
