import GitHubAPI
import Combine

@MainActor
final class RepositoryDetailViewModel: ObservableObject {
    let fullName: String
    @Published var networkCount: Int?
    @Published var refreshError: Error?

    var api: GitHubAPIProviding
    
    init(_ fullName: String, _ api: GitHubAPIProviding) {
        self.fullName = fullName
        self.api = api
    }
        
    func refresh() async throws {
        do {
            let repo = try await api.fetchRepository(with: fullName)
            networkCount = repo.networkCount
        } catch {
            networkCount = nil
            throw error
        }
    }
    
    func setRefreshError(_ error: Error?) { refreshError = error }
}

