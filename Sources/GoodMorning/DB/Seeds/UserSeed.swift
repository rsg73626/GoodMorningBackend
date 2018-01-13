import Foundation

class UserSeed: SeedProtocol{
    
    static func createDevelopmentSeeds(){
        let contact = Contact(content: "11 1234 1234", type: .Cellphone)
        let user = User(name: "Renan", email: "renan@email.com", photo: "userPhoto", about: "User about", contacts: [contact])
        UserQuery.create(user, password: "12345678")
    }
    
    static func createTestingSeeds(){
        
    }
    
    static func createProductionSeeds(){
        
    }
}

