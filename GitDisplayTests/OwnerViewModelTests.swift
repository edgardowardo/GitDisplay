import Testing
import GitHubAPI
import Foundation

@testable import GitDisplay

@Suite("OwnerViewModel")
struct OwnerViewModelTests {
    
    @Test("Initializes with swiftlang if no owner saved")
    func testInitialEmptyState() async throws {
        UserDefaults(suiteName: "OwnerViewModelTestSuite.default")?.removePersistentDomain(forName: "OwnerViewModelTestSuite")
        let service = GitHubOwnerService(userDefaults: UserDefaults(suiteName: "OwnerViewModelTestSuite.default")!)
        let vm = await OwnerViewModel(service: service)
        await MainActor.run {
            #expect(vm.name == "swiftlang")
            #expect(vm.type == .orgs)
        }
    }

    @Test("Initializes with saved owner from service")
    func testInitializesWithSavedOwner() async throws {
        let service = GitHubOwnerService(userDefaults: UserDefaults(suiteName: "OwnerViewModelTestSuite.octotat")!)
        service.save(owner: GitHubOwner(name: "octocat", type: .users))
        let vm = await OwnerViewModel(service: service)
        await MainActor.run {
            #expect(vm.name == "octocat")
            #expect(vm.type == .users)
        }
    }

    @Test("Save persists owner to service")
    func testSavePersists() async throws {
        let service = GitHubOwnerService(userDefaults: UserDefaults(suiteName: "OwnerViewModelTestSuite.apple")!)
        let vm = await OwnerViewModel(service: service)
        await MainActor.run {
            vm.name = "apple"
            vm.type = .orgs
            vm.save()
        }
        let stored = service.load()
        await MainActor.run {
            #expect(stored.name == "apple")
            #expect(stored.type == .orgs)
        }
    }
}
