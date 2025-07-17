import Combine

enum ModalRoute: Identifiable {
    case settings, owner
    var id: String {
        switch self {
        case .settings: return "settings"
        case .owner: return "owner"
        }
    }
}

class ModalManager: ObservableObject {
    @Published var route: ModalRoute?
    @Published var refreshError: Error?
    
    init(tokenManager: TokenManagerProviding) {
        self.tokenManager = tokenManager
    }
    
    private let tokenManager: TokenManagerProviding
    func showOwner() { route = .owner }
    func showSettings() { route = .settings }
    func showSettingsIfNoToken() {
        let token = tokenManager.getToken()
        if  token == nil || token != nil && token!.isEmpty {
            route = .settings
        }
    }
    func dismiss() { route = nil }
    func setRefreshError(_ error: Error?) { refreshError = error }
}
