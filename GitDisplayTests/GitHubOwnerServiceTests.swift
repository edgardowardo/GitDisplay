import Testing
import Foundation
@testable import GitHubAPI

@Suite("GitHubOwnerService")
struct GitHubOwnerServiceTests {
    @Test("Save and Load GitHubOwner")
    func testSaveAndLoad() async throws {
        let userDefaults = UserDefaults(suiteName: "TestSuite.testSaveAndLoad")!
        let service = GitHubOwnerService(userDefaults: userDefaults)
        let owner = GitHubOwner(name: "apple", type: .orgs)
        service.save(owner: owner)

        let loaded = service.load()
        #expect(loaded.name == owner.name)
        #expect(loaded.type == owner.type)
    }

    @Test("Clear GitHubOwner")
    func testClear() async throws {
        let userDefaults = UserDefaults(suiteName: "TestSuite.testClear")!
        let service = GitHubOwnerService(userDefaults: userDefaults)
        let owner = GitHubOwner(name: "user1", type: .users)
        service.save(owner: owner)
        service.clear()
        let loaded = service.load()
        #expect(loaded.name == "swiftlang")
    }
}
