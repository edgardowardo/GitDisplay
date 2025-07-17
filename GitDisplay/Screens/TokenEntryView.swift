import SwiftUI

struct TokenEntryView: View {
    @ObservedObject var viewModel: TokenViewModel
    public var onDismiss: ((_ isCancelled: Bool, _ token: String?) -> Void)?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Token")) {
                    SecureField("Token", text: $viewModel.token)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss?(true, nil) }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onDismiss?(false, viewModel.token) }
                }
            }
            .navigationTitle("Token Entry")
        }
    }
}

#if DEBUG
#Preview {
    TokenEntryView(viewModel: TokenViewModel(), onDismiss: { (isCancelled, token) in
        if let token = token, !isCancelled {
            TokenManager().saveToken(token)
        }
    })
}
#endif
