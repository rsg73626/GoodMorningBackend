import Foundation

class Parser{
    //MARK: Singleton
    private static let _shared: Parser = Parser()
    static var shared: Parser {get {return _shared}}
    
    //MARK: Properties
    private var dateFormatter = DateFormatter()
    
    //MARK: Initializers
    private init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = Locale.init(identifier: "pt_BR")
        self.dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    }
    
    //MARK: Parse functions
    func dateToString(_ date: Date, format: String) -> String?{
        self.dateFormatter.dateFormat = format
        return self.dateFormatter.string(from: date)
    }
    
    func stringToDate(_ string: String, format: String) -> Date?{
        self.dateFormatter.dateFormat = format
        return self.dateFormatter.date(from: string)
    }
    
    
    
}

