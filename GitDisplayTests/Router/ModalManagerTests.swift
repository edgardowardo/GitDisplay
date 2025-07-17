// Create a unit test file for ModalManager, focusing on modal routing logic.
import Testing
import Foundation

// Import the file/module where ModalManager and ModalRoute are defined, if needed.
@testable import GitDisplay

final class MockTokenManager: TokenManagerProviding {
    func getToken() -> String? { nil }
    func saveToken(_ token: String) { }
    init() {}
}

@Suite("ModalManager Routing Logic")
struct ModalManagerTests {
    
    let mockTokenManager = MockTokenManager()
    
    @Test("Initial state is nil")
    func initialStateIsNil() async throws {
        let manager = ModalManager(tokenManager: mockTokenManager)
        #expect(manager.route == nil)
        #expect(manager.refreshError == nil)
    }
    
    @Test("Show settings route")
    func showSettingsRoute() async throws {
        let manager = ModalManager(tokenManager: mockTokenManager)
        manager.showSettings()
        #expect(manager.route == .settings)
    }
    
    @Test("Show owner route")
    func showOwnerRoute() async throws {
        let manager = ModalManager(tokenManager: mockTokenManager)
        manager.showOwner()
        #expect(manager.route == .owner)
    }
    
    @Test("Dismiss route")
    func dismissRoute() async throws {
        let manager = ModalManager(tokenManager: mockTokenManager)
        manager.showOwner()
        manager.dismiss()
        #expect(manager.route == nil)
    }
    
    @Test("Set and clear refresh error")
    func setAndClearRefreshError() async throws {
        let manager = ModalManager(tokenManager: mockTokenManager)
        let error = NSError(domain: "test", code: 123)
        manager.setRefreshError(error)
        #expect(manager.refreshError != nil)
        manager.setRefreshError(nil)
        #expect(manager.refreshError == nil)
    }
}

