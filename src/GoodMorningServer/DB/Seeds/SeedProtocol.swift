import Foundation

protocol SeedProtocol {
    static func createDevelopmentSeeds()
    static func createTestingSeeds()
    static func createProductionSeeds()
}
