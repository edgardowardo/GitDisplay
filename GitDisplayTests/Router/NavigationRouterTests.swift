import Testing
import SwiftUI
@testable import GitDisplay

@Suite("NavigationRouter Tests")
struct NavigationRouterTests {
    @Test("Initial path is empty")
    func initialPathIsEmpty() async throws {
        let router = NavigationRouter()
        #expect(router.path.isEmpty, "Path should start empty")
    }

    @Test("goToRepositoryDetail appends route")
    func goToRepositoryDetailAppendsRoute() async throws {
        let router = NavigationRouter()
        router.goToRepositoryDetail(name: "swift")
        #expect(router.path.count == 1)
    }

    @Test("pop removes last route")
    func popRemovesLastRoute() async throws {
        let router = NavigationRouter()
        router.goToRepositoryDetail(name: "swift")
        router.pop()
        #expect(router.path.isEmpty, "Path should be empty after pop")
    }

    @Test("clear removes all elements from path")
    func clearRemovesAllElements() async throws {
        let router = NavigationRouter()
        router.goToRepositoryDetail(name: "swift")
        router.goToRepositoryDetail(name: "llbuild")
        router.clear()
        #expect(router.path.isEmpty, "Path should be empty after clear")
    }
}

