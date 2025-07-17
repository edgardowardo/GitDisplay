import Testing
import SwiftUI
@testable import GitDisplay

@Suite("DeepLink Tests")
struct DeepLinkTests {

    @Test("DeepLink parses repository URL")
    func deepLinkParsesRepositoryURL() async throws {
        let url = URL(string: "gitdisplay://repository/swiftlang/swift")!
        let deepLink = await DeepLink(url: url)
        switch deepLink {
        case .repository(let fullName):
            #expect(fullName == "swiftlang/swift")
        default:
            #expect(Bool(false), "Expected repository deep link")
        }
    }

    @Test("DeepLink returns nil for invalid URL")
    func deepLinkReturnsNilForInvalidURL() async throws {
        let url = URL(string: "gitdisplay://somethingelse")!
        let deepLink = await DeepLink(url: url)
        #expect(deepLink == nil)
    }

    @Test("handle(deepLink:) navigates to repo detail")
    func handleDeepLinkNavigatesToRepo() async throws {
        let router = await NavigationRouter()
        let url = URL(string: "gitdisplay://repository/swiftlang/swift")!
        let deepLink = try #require(DeepLink(url: url))
        DeepLinkManager.shared.pendingDeepLink = deepLink
        router.handlePendingDeepLink(DeepLinkManager.shared)
        #expect(router.path.count == 1)
        #expect(router.path == NavigationPath([AppRoute.repositoryDetail(name: "swiftlang/swift")]))
    }
}
