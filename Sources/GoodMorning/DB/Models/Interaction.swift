import StORM
import PostgresStORM

class Interaction: PostgresStORM, Codable {
    
    //MARK: Properties
    var id: Int = 0
    var greeting: Greeting?
    var isRetributed: Bool = false
    var isLiked: Bool = false
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case Greeting = "greeting"
        case GreetingId = "greeting_id"
        case IsRetributed = "is_retributed"
        case IsLiked = "is_liked"
    }
    
    //MARK: Initializers
    override init(){
        self.greeting = nil
        super.init()
    }
    
    init(greeting: Greeting, isRetributed: Bool, isLiked: Bool) {
        self.greeting = greeting
        self.isRetributed = isRetributed
        self.isLiked = isLiked
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .Id)
        self.greeting = try values.decode(Greeting.self, forKey: .Greeting)
        self.isRetributed = try values.decode(Bool.self, forKey: .IsRetributed)
        self.isLiked = try values.decode(Bool.self, forKey: .IsLiked)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.greeting?.id, forKey: .GreetingId)
        try container.encode(self.isRetributed, forKey: .IsRetributed)
        try container.encode(self.isLiked, forKey: .IsLiked)
    }
    
    //MARK: PostgresStORM
    override open func table() -> String { return "interaction" }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        let greetingId = this.data["id_greeting"] as? Int ?? 0
        greeting = GreetingQuery.readById(greetingId)
        isRetributed = this.data["is_retribuited"] as? Bool ?? false
        isLiked = this.data["is_liked"] as? Bool ?? false
    }
    
    func rows() -> [Interaction] {
        var rows = [Interaction]()
        for i in 0..<self.results.rows.count {
            let row = Interaction()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
