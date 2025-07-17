import Foundation

enum DeepLink {
    /// e.g.  gitdisplay://repository/swiftlang/swift
    case repository(fullName: String)
    
    init?(url: URL) {
        guard url.scheme == "gitdisplay",
              url.host == "repository" else { return nil }
        let pathComponents = url.path.split(separator: "/").map(String.init)
        guard pathComponents.count == 2 else { return nil }
        let owner = pathComponents[0]
        let repo = pathComponents[1]
        self = .repository(fullName: "\(owner)/\(repo)")
    }
}
