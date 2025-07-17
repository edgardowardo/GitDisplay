import Combine

/// ViewModel for handling GitHub API token entry and validation.
@MainActor
final class TokenViewModel: ObservableObject {
    @Published var token: String = ""
    
    init(token: String = "") {
        self.token = token
    }
    
    // Extend with validation or storage logic as needed
}
