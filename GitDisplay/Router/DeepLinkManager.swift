final class DeepLinkManager: PendingDeepLinkProviding {
    
    static let shared = DeepLinkManager()

    var pendingDeepLink: DeepLink?

    func clearPendingDeepLink() {
        pendingDeepLink = nil
    }

    init() {}
}

protocol PendingDeepLinkProviding {
    var pendingDeepLink: DeepLink? { get }
    func clearPendingDeepLink()
}

