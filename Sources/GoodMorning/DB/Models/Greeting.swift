import StORM
import PostgresStORM
import Foundation

class Greeting: PostgresStORM, Codable{
    
    //MARK: Properties
    var id: Int? = 0
    var type: GreetingType!
    var message: String!
    var date: Date!
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case GreetingType = "type"
        case Message = "message"
        case Date = "date"
    }
    
    //MARK: Initializers
    override init(){
        self.id = nil
        self.type = GreetingType.GoodMorning
        self.message = ""
        self.date = Date()
        super.init()
    }
    
    init(type: GreetingType, message: String, date: Date) {
        self.id = nil
        self.type = type
        self.message = message
        self.date = date
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do { self.id = try values.decode(Int.self, forKey: .Id) } catch { self.id = nil }
        let type = try values.decode(Int.self, forKey: .GreetingType)
        self.type = type == 1 ? GreetingType.GoodMorning : type == 2 ? GreetingType.GoodAfternoon : type == 3 ? GreetingType.GoodEvening : GreetingType.GoodDawn
        self.message = try values.decode(String.self, forKey: .Message)
        let dateString = try values.decode(String.self, forKey: .Date)
        self.date = Parser.shared.stringToDate(dateString, format: "yyyy-MM-dd")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.type.rawValue, forKey: .GreetingType)
        try container.encode(self.message, forKey: .Message)
        try container.encode(Parser.shared.dateToString(self.date!, format: "yyyy-MM-dd"), forKey: .Date)
    }
    
    //MARK: PostgresStORM
    override open func table() -> String { return GreetingTable.tableName }
    
    override func to(_ this: StORMRow) {
        let greetingType: Int = this.data[GreetingTable.type] as! Int
        let stringDate: String = this.data[GreetingTable.creationString] as! String
        id = this.data[GreetingTable.id] as? Int ?? 0
        message = this.data[GreetingTable.message] as! String
        date = Parser.shared.stringToDate(stringDate, format: "yyyy-MM-dd")
        type = greetingType == 1 ? GreetingType.GoodMorning : greetingType == 2 ? GreetingType.GoodAfternoon : greetingType == 3 ? GreetingType.GoodEvening : GreetingType.GoodDawn
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
