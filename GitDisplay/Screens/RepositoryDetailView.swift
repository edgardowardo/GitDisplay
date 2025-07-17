import SwiftUI

struct RepositoryDetailView: View {
    
    @ObservedObject private var viewModel: RepositoryDetailViewModel
    private let itemViewModel: RepositoryItemViewModel
    
    
    init(_ viewModel: RepositoryDetailViewModel, _ itemViewModel: RepositoryItemViewModel) {
        self.viewModel = viewModel
        self.itemViewModel = itemViewModel
    }

    var body: some View {
        List {
            Group {
                RepositoryValueView(key: "Name") {
                    Text(itemViewModel.name)
                        .foregroundColor(.secondary)
                }

                RepositoryValueView(key: "Description") {
                    Text(itemViewModel.description)
                        .foregroundColor(.secondary)
                }

                RepositoryValueView(key: "Stars") {
                    Text("\(itemViewModel.starCount)")
                        .foregroundColor(.secondary)
                }

                RepositoryValueView(key: "Forks") {
                    if let networkCount = viewModel.networkCount {
                        Text("\(networkCount)")
                            .foregroundColor(.secondary)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .navigationTitle(itemViewModel.name)
        .task {
            do {
                try await viewModel.refresh()
            } catch {
                viewModel.setRefreshError(error)
            }
        }
        .alert("Refresh Failed", isPresented: .constant(viewModel.refreshError != nil), presenting: viewModel.refreshError) { error in
            Button("OK") { viewModel.setRefreshError(nil) }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
}

private struct RepositoryValueView<Value: View>: View {
    let key: String
    let value: Value

    var body: some View {
        VStack(alignment: .leading) {
            Text(key)
                .font(.headline)
            value
        }
    }

    init(key: String, @ViewBuilder value: () -> Value) {
        self.key = key
        self.value = value()
    }
}
