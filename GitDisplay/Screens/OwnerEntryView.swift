import SwiftUI
import GitHubAPI

public struct OwnerEntryView: View {
    @ObservedObject var viewModel: OwnerViewModel
    public var onDismiss: ((_ isCancelled: Bool) -> Void)?

    public init(viewModel: OwnerViewModel, onDismiss: ((_ isCancelled: Bool) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Owner Name")) {
                    TextField("Enter owner name", text: $viewModel.name)
                        .autocapitalization(.none)
                }
                Section(header: Text("Owner Type")) {
                    Picker("Type", selection: $viewModel.type) {
                        ForEach(GitHubOwnerType.allCases, id: \.self) { type in
                            Text(label(for: type)).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Owner Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss?(true) }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        onDismiss?(false)
                    }
                }
            }
        }
    }

    private func label(for type: GitHubOwnerType) -> String {
        switch type {
        case .orgs: return "Organisation"
        case .users: return "Users"
        }
    }
}
