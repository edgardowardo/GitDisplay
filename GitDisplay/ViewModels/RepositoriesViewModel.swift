import Combine
import GitHubAPI

@MainActor
public final class RepositoriesViewModel: ObservableObject {
    @Published public var repositories: [RepositoryItemViewModel] = []
    @Published public var title = ""
    @Published public var isLoading: Bool = false
    
    var api: GitHubAPIProviding
    private let ownerService: GitHubOwnerServiceProviding
    private let tokenManager: TokenManagerProviding
    
    public init(api: GitHubAPIProviding, ownerService: GitHubOwnerServiceProviding = GitHubOwnerService(), tokenManager: TokenManagerProviding) {
        self.api = api
        self.ownerService = ownerService
        self.tokenManager = tokenManager
    }
    
    public func refresh() async throws {
        let owner = ownerService.load()
        title = owner.name
        isLoading = true
        do {
            repositories = try await api.fetchRepositories(from: owner).map {
                .init(id: $0.id, name: $0.name, fullName: $0.fullName, description: $0.description ?? "No description", starCount: String($0.stargazersCount))
            }
            isLoading = false
        } catch {
            repositories = []
            isLoading = false
            throw error
        }
    }
    
    public func setToken(_ token: String?) {
        if let token = token {
            tokenManager.saveToken(token)
        }
        api = GitHubAPI(authorisationToken: token != nil && token == "" ? nil : token )
    }
}

public struct RepositoryItemViewModel: Identifiable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let description: String
    public let starCount: String
}
