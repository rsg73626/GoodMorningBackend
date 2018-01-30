enum ContactType: Int{
    case Cellphone = 1
    case SocialNetwork = 2
    case Other = 3
}

enum GreetingType: Int{
    case GoodMorning = 1
    case GoodAfternoon = 2
    case GoodEvening = 3
    case GoodDawn = 4
}

struct UserTable {
    static let tableName = "goodmorning_user"
    static let id = "id"
    static let name = "name"
    static let email = "email"
    static let password = "password"
    static let about = "about"
    static let photo = "photo"
}

struct ContactTable {
    static let tableName = "contact"
    static let id = "id"
    static let content = "content"
    static let type = "type"
    static let owner = "owner"
}

struct GreetingTable {
    static let tableName = "greeting"
    static let id = "id"
    static let type = "type"
    static let creator = "creator"
    static let message = "message"
    static let creationString = "creation_string"
    static let creationDate = "creation_date"
}

struct GreetingPreferenceTable {
    static let tableName = "greeting_preference"
    static let id = "id"
    static let user = "id_user"
    static let type = "type"
    static let isActive = "is_active"
    static let fromTime = "from_time"
    static let fromString = "from_string"
}

struct InteractionTable {
    static let tableName = "interaction"
    static let id = "id"
    static let greeting = "greeting"
    static let receiver = "receiver"
    static let isRetributed = "is_retributed"
    static let isLikedBySender = "is_liked_by_sender"
    static let isLikedByReceiver = "is_liked_by_receiver"
}
