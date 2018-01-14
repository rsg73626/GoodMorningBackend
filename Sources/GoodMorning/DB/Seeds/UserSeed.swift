import Foundation

class UserSeed: SeedProtocol{
    
    static func createDevelopmentSeeds(){
        let contact = Contact(content: "11 1234 1234", type: .Cellphone)
        let user = User(name: "Renan", email: "renan@email.com", password: "123456", photo: "userPhoto", about: "User about", contacts: [contact])
        if let createdUser = UserQuery.create(user) {
            print("User created with id \(createdUser.id!).")
        }
    }
    
    static func createTestingSeeds(){
        
    }
    
    static func createProductionSeeds(){
        
    }
}

