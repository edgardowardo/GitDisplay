import Combine
import SwiftUI

enum AppRoute: Hashable {
    case repositoryDetail(name: String)
}

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()

    func goToRepositoryDetail(name: String) {
        path.append(AppRoute.repositoryDetail(name: name))
    }
    
    func pop() {
        path.removeLast()
    }
    
    func clear() {
        path.removeLast(path.count)
    }
        
    func handlePendingDeepLink(_ provider: PendingDeepLinkProviding) {
        if let deepLink = provider.pendingDeepLink {
            handle(deepLink: deepLink)
            provider.clearPendingDeepLink()
        }
    }
    
    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .repository(fullName: let fullName):
            goToRepositoryDetail(name: fullName)
        }
    }
}
