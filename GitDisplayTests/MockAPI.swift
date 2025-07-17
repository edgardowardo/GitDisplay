import Foundation
import GitHubAPI

class MockAPI: GitHubAPIProviding {

    func fetchRepositories(from owner: GitHubOwner) async throws -> [GitHubMinimalRepository] {
        guard let data = MockData.repositories.data(using: .utf8) else { throw ResultsRepositoryError.invalidJSON }
        let decoder = JSONDecoder()
        let repositories = try decoder.decode([GitHubMinimalRepository].self, from: data)
        return repositories
    }
    
    func fetchRepository(with fullName: String) async throws -> GitHubFullRepository {
        guard let data = MockData.repository1.data(using: .utf8) else { throw ResultsRepositoryError.invalidJSON }
        let decoder = JSONDecoder()
        let repository = try decoder.decode(GitHubFullRepository.self, from: data)
        return repository
    }
}

struct MockData {
    
    static let repository1 = """
    {
      "description" : "The Swift Programming Language",
      "fullName" : "swiftlang/swift",
      "id" : 44838949,
      "name" : "swift",
      "networkCount" : 10488,
      "stargazersCount" : 68741
    }    
    """
    
    static let repository2 = """
    {
      "description" : "A low-level build system, used by Xcode and the Swift Package Manager",
      "fullName" : "swiftlang/swift-llbuild",
      "id" : 44838988,
      "name" : "swift-llbuild",
      "networkCount" : 211,
      "stargazersCount" : 1218
    }    
    """
    
    static let repositories = """
        [
          {
            "description" : "The Swift Programming Language",
            "fullName" : "swiftlang/swift",
            "id" : 44838949,
            "name" : "swift",
            "stargazersCount" : 68740
          },
          {
            "description" : "A low-level build system, used by Xcode and the Swift Package Manager",
            "fullName" : "swiftlang/swift-llbuild",
            "id" : 44838988,
            "name" : "swift-llbuild",
            "stargazersCount" : 1218
          },
          {
            "description" : "The Package Manager for the Swift Programming Language",
            "fullName" : "swiftlang/swift-package-manager",
            "id" : 44840041,
            "name" : "swift-package-manager",
            "stargazersCount" : 9946
          },
          {
            "description" : "This maintains proposals for changes and user-visible enhancements to the Swift Programming Language.",
            "fullName" : "swiftlang/swift-evolution",
            "id" : 45497910,
            "name" : "swift-evolution",
            "stargazersCount" : 15611
          },
          {
            "description" : "The Foundation Project, providing core utilities, internationalization, and OS independence",
            "fullName" : "swiftlang/swift-corelibs-foundation",
            "id" : 45863890,
            "name" : "swift-corelibs-foundation",
            "stargazersCount" : 5369
          },
          {
            "description" : "The libdispatch Project, (a.k.a. Grand Central Dispatch), for concurrency on multicore hardware",
            "fullName" : "swiftlang/swift-corelibs-libdispatch",
            "id" : 45863965,
            "name" : "swift-corelibs-libdispatch",
            "stargazersCount" : 2512
          },
          {
            "description" : "The XCTest Project, A Swift core library for providing unit test support",
            "fullName" : "swiftlang/swift-corelibs-xctest",
            "id" : 45864027,
            "name" : "swift-corelibs-xctest",
            "stargazersCount" : 1163
          },
          {
            "description" : "Example package for use with the Swift Package Manager",
            "fullName" : "swiftlang/example-package-playingcard",
            "id" : 45936359,
            "name" : "example-package-playingcard",
            "stargazersCount" : 337
          },
          {
            "description" : "Example package for use with the Swift Package Manager",
            "fullName" : "swiftlang/example-package-deckofplayingcards",
            "id" : 45936445,
            "name" : "example-package-deckofplayingcards",
            "stargazersCount" : 196
          },
          {
            "description" : "Example package for use with the Swift Package Manager",
            "fullName" : "swiftlang/example-package-dealer",
            "id" : 45936484,
            "name" : "example-package-dealer",
            "stargazersCount" : 356
          },
          {
            "description" : "Docker Official Image packaging for Swift",
            "fullName" : "swiftlang/swift-docker",
            "id" : 47356910,
            "name" : "swift-docker",
            "stargazersCount" : 1390
          },
          {
            "description" : "Automated tests for validating the generated Swift snapshots behave correctly",
            "fullName" : "swiftlang/swift-integration-tests",
            "id" : 47450638,
            "name" : "swift-integration-tests",
            "stargazersCount" : 112
          },
          {
            "description" : "CommonMark parsing and rendering library and program in C",
            "fullName" : "swiftlang/swift-cmark",
            "id" : 47902653,
            "name" : "swift-cmark",
            "stargazersCount" : 295
          },
          {
            "description" : "The infrastructure and project index comprising the Swift source compatibility suite.",
            "fullName" : "swiftlang/swift-source-compat-suite",
            "id" : 78574614,
            "name" : "swift-source-compat-suite",
            "stargazersCount" : 285
          },
          {
            "description" : "Swift Community-Hosted Continuous Integration",
            "fullName" : "swiftlang/swift-community-hosted-continuous-integration",
            "id" : 111026478,
            "name" : "swift-community-hosted-continuous-integration",
            "stargazersCount" : 119
          },
          {
            "description" : "Stress testing utilities for Swift's tooling",
            "fullName" : "swiftlang/swift-stress-tester",
            "id" : 124606805,
            "name" : "swift-stress-tester",
            "stargazersCount" : 213
          },
          {
            "description" : "Contains common infrastructural code for both SwiftPM and llbuild.",
            "fullName" : "swiftlang/swift-tools-support-core",
            "id" : 127018945,
            "name" : "swift-tools-support-core",
            "stargazersCount" : 416
          },
          {
            "description" : "A set of Swift libraries for parsing, inspecting, generating, and transforming Swift source code.",
            "fullName" : "swiftlang/swift-syntax",
            "id" : 143079594,
            "name" : "swift-syntax",
            "stargazersCount" : 3446
          },
          {
            "description" : "Language Server Protocol implementation for Swift and C-based languages",
            "fullName" : "swiftlang/sourcekit-lsp",
            "id" : 154773196,
            "name" : "sourcekit-lsp",
            "stargazersCount" : 3547
          },
          {
            "description" : "Index database library for use with sourcekit-lsp",
            "fullName" : "swiftlang/indexstore-db",
            "id" : 154773489,
            "name" : "indexstore-db",
            "stargazersCount" : 353
          },
          {
            "description" : "Formatting technology for Swift source code",
            "fullName" : "swiftlang/swift-format",
            "id" : 196084046,
            "name" : "swift-format",
            "stargazersCount" : 2701
          },
          {
            "description" : "Swift compiler driver reimplementation in Swift",
            "fullName" : "swiftlang/swift-driver",
            "id" : 214091865,
            "name" : "swift-driver",
            "stargazersCount" : 821
          },
          {
            "description" : "The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.  This fork is used to manage Swift’s stable releases of Clang as well as support the Swift project.",
            "fullName" : "swiftlang/llvm-project",
            "id" : 215875945,
            "name" : "llvm-project",
            "stargazersCount" : 1177
          },
          {
            "description" : "Swift Evolution preview package for SE-0270.",
            "fullName" : "swiftlang/swift-se0270-range-set",
            "id" : 238744366,
            "name" : "swift-se0270-range-set",
            "stargazersCount" : 20
          },
          {
            "description" : "A collection of packages and tooling for generating and consuming package feeds.",
            "fullName" : "swiftlang/swift-package-collection-generator",
            "id" : 306742487,
            "name" : "swift-package-collection-generator",
            "stargazersCount" : 111
          },
          {
            "description" : "Documentation compiler that produces rich API reference documentation and interactive tutorials for your Swift framework or package.",
            "fullName" : "swiftlang/swift-docc",
            "id" : 387531333,
            "name" : "swift-docc",
            "stargazersCount" : 1251
          },
          {
            "description" : "A Swift package for parsing, building, editing, and analyzing Markdown documents.",
            "fullName" : "swiftlang/swift-markdown",
            "id" : 387532152,
            "name" : "swift-markdown",
            "stargazersCount" : 2986
          },
          {
            "description" : "Web renderer for Swift-DocC documentation.",
            "fullName" : "swiftlang/swift-docc-render",
            "id" : 387532899,
            "name" : "swift-docc-render",
            "stargazersCount" : 332
          },
          {
            "description" : "A Swift package for encoding and decoding Swift Symbol Graph files.",
            "fullName" : "swiftlang/swift-docc-symbolkit",
            "id" : 387533186,
            "name" : "swift-docc-symbolkit",
            "stargazersCount" : 194
          },
          {
            "fullName" : "swiftlang/swift-installer-scripts",
            "id" : 387851231,
            "name" : "swift-installer-scripts",
            "stargazersCount" : 76
          }
        ]        
        """
}
