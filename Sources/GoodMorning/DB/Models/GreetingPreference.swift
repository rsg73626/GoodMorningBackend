import StORM
import PostgresStORM
import Foundation

class GreetingPreference: PostgresStORM, Codable {
    
    //MARK: Properties
    var id: Int? = 0
    var type: GreetingType!
    var isActive: Bool = true
    var from: Date!
    
    //MARK: Types
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case GreetingType = "type"
        case IsActive = "is_active"
        case From = "from"
    }
    
    //MARK: Initializers
    override init() {
        self.id = nil
        self.type = GreetingType.GoodMorning
        self.isActive = true
        self.from = nil
    }
    
    init(type: GreetingType, isActive: Bool, from: Date) {
        self.type = type
        self.isActive = isActive
        self.from = from
    }
    
    //MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do { self.id = try values.decode(Int.self, forKey: .Id) } catch { self.id = nil }
        
        do {
            let type = try values.decode(Int.self, forKey: .GreetingType)
            self.type = type == 1 ? GreetingType.GoodMorning : type == 2 ? GreetingType.GoodAfternoon : type == 3 ? GreetingType.GoodEvening : GreetingType.GoodDawn
        } catch {
            self.type = .GoodMorning
        }
        
        self.isActive = try values.decode(Bool.self, forKey: .IsActive)
        let fromString = try values.decode(String.self, forKey: .From)
        self.from = Parser.shared.stringToDate(fromString, format: "yyyy-MM-dd HH:mm")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .Id)
        try container.encode(self.type.rawValue, forKey: .GreetingType)
        try container.encode(self.isActive, forKey: .IsActive)
        try container.encode(Parser.shared.dateToString(self.from!, format: "yyyy-MM-dd HH:mm"), forKey: .From)
    }
    
    //MARK: PostgresStORM
    override open func table() -> String {return GreetingPreferenceTable.tableName}
    
    override func to(_ this: StORMRow) {
        let greetingType: Int = this.data[GreetingPreferenceTable.type] as! Int
        let stringFrom: String = this.data[GreetingPreferenceTable.fromString] as! String
        id = this.data[GreetingPreferenceTable.id] as? Int ?? 0
        type = greetingType == 1 ? GreetingType.GoodMorning : greetingType == 2 ? GreetingType.GoodAfternoon : greetingType == 3 ? GreetingType.GoodEvening : GreetingType.GoodDawn
        isActive = this.data[GreetingPreferenceTable.isActive] as! Bool
        from = Parser.shared.stringToDate(stringFrom, format: "yyyy-MM-dd HH:mm")
    }
    
    func rows() -> [GreetingPreference] {
        var rows = [GreetingPreference]()
        for i in 0..<self.results.rows.count {
            let row = GreetingPreference()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
