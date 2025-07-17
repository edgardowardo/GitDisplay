import Testing
import GitHubAPI
import Foundation

@testable import GitDisplay

final class MockOwnerService: GitHubOwnerServiceProviding {
    func load() -> GitHubOwner { GitHubOwner(name: "swiftlang", type: .orgs) }
    func save(owner: GitHubOwner) { }
}

@Suite("RepositoriesViewModel")
struct RepositoriesViewModelTests {
    
    @Test("refresh() loads repositories using MockAPI")
    func testRefreshLoadsRepositories() async throws {
        let viewModel = await RepositoriesViewModel(api: MockAPI(), ownerService: MockOwnerService(), tokenManager: MockTokenManager())
        try await viewModel.refresh()
        await MainActor.run {
            #expect(!viewModel.repositories.isEmpty, "Repositories should not be empty")
            #expect(viewModel.repositories.first?.name == "swift", "First repository name should be 'swift'")
        }
    }

    @Test("refresh() sets the title to the owner name from OwnerViewModel")
    func testRefreshSetsTitle() async throws {
        let mockOwnerService = MockOwnerService()
        let viewModel = await RepositoriesViewModel(api: MockAPI(), ownerService: MockOwnerService(), tokenManager: MockTokenManager())
        try await viewModel.refresh()
        await MainActor.run {
            #expect(viewModel.title == "swiftlang", "Title should be 'swiftlang'")
        }
    }
}

