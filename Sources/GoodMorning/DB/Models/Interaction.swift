import StORM
import PostgresStORM

class Interaction: PostgresStORM, Codable {
    
    //MARK: Properties
    var id: Int? = 0
    var greeting: Greeting?
    var isRetributed: Bool!
    var isLikedBySender: Bool!
    var isLikedByReceiver: Bool!
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case Greeting = "greeting"
        case IsRetributed = "is_retributed"
        case IsLikedBySender = "is_liked_by_sender"
        case IsLikedByReceiver = "is_liked_by_receiver"
    }
    
    //MARK: Initializers
    override init(){
        self.id = nil
        self.greeting = nil
        self.isRetributed = false
        self.isLikedBySender = false
        self.isLikedByReceiver = false
        super.init()
    }
    
    init(greeting: Greeting, isRetributed: Bool, isLikedBySender: Bool, isLikedByReceiver: Bool) {
        self.id = nil
        self.greeting = greeting
        self.isRetributed = isRetributed
        self.isLikedBySender = isLikedBySender
        self.isLikedByReceiver = isLikedByReceiver
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do { self.id = try values.decode(Int.self, forKey: .Id) } catch { self.id = nil }
        self.greeting = try values.decode(Greeting.self, forKey: .Greeting)
        self.isRetributed = try values.decode(Bool.self, forKey: .IsRetributed)
        self.isLikedBySender = try values.decode(Bool.self, forKey: .IsLikedBySender)
        self.isLikedByReceiver = try values.decode(Bool.self, forKey: .IsLikedByReceiver)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.greeting!, forKey: .Greeting)
        try container.encode(self.isRetributed, forKey: .IsRetributed)
        try container.encode(self.isLikedBySender, forKey: .IsLikedBySender)
        try container.encode(self.isLikedByReceiver, forKey: .IsLikedByReceiver)
    }
    
    //MARK: PostgresStORM
    override open func table() -> String { return InteractionTable.tableName }
    
    override func to(_ this: StORMRow) {
        let greetingId = this.data[InteractionTable.greeting] as! Int
        id = this.data[InteractionTable.id] as? Int ?? 0
        greeting = GreetingQuery.readById(greetingId)
        isRetributed = this.data[InteractionTable.isRetributed] as! Bool
        isLikedBySender = this.data[InteractionTable.isLikedBySender] as! Bool
        isLikedByReceiver = this.data[InteractionTable.isLikedByReceiver] as! Bool
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
