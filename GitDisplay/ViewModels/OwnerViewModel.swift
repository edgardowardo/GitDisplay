import Combine
import GitHubAPI

@MainActor
public final class OwnerViewModel: ObservableObject {
    @Published public var name: String = "swiftlang"
    @Published public var type: GitHubOwnerType = .orgs
    
    var owner: GitHubOwner { GitHubOwner(name: name, type: type) }
    
    private let service: GitHubOwnerServiceProviding

    public init(service: GitHubOwnerServiceProviding = GitHubOwnerService()) {
        self.service = service
        let owner = service.load()
        self.name = owner.name
        self.type = owner.type
    }

    public func save() {
        let owner = GitHubOwner(name: name, type: type)
        service.save(owner: owner)
    }
}
