import SwiftUI
import GitHubAPI

struct RepositoriesView: View {
    @ObservedObject private var viewModel: RepositoriesViewModel
    @StateObject private var router: NavigationRouter
    @StateObject private var modalManager: ModalManager
    private let tokenManager: TokenManagerProviding

    init(_ viewModel: RepositoriesViewModel, _ router: NavigationRouter, _ tokenManager: TokenManagerProviding) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._router = StateObject(wrappedValue: router)
        self._modalManager = StateObject(wrappedValue: .init(tokenManager: tokenManager))
        self.tokenManager = tokenManager
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(viewModel.repositories) { item in
                    Button(action: {
                        router.goToRepositoryDetail(name: item.fullName)
                    }) {
                        RepositoryItemView(viewModel: item)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                await refreshViewModel()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { modalManager.showOwner() }) {
                        Image(systemName: "person.fill")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    Button(action: { modalManager.showSettings() }) {
                        Image(systemName: "gear")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .repositoryDetail(name: let fullName):
                    if let itemVM = viewModel.repositories.first(where: { $0.fullName == fullName }) {
                        RepositoryDetailView(RepositoryDetailViewModel(fullName, viewModel.api), itemVM)
                    } else {
                        Text("Repository not found")
                    }
                }
            }
            .task {
                await refreshViewModel()
                modalManager.showSettingsIfNoToken()
            }
            
            if viewModel.isLoading {
                ZStack {
                    Color(.systemBackground).opacity(0.5).ignoresSafeArea()
                    ProgressView()
                }
            }
        }
        .environmentObject(router)
        .sheet(item: $modalManager.route) { route in
            switch route {
            case .owner: OwnerEntryView(viewModel: OwnerViewModel()) { isCancelled in
                modalManager.dismiss()
                guard !isCancelled else { return }
                Task { await refreshViewModel() }
            }
            case .settings:
                let t = tokenManager.getToken() ?? ""
                TokenEntryView(viewModel: TokenViewModel(token: t)) { isCancelled, token in
                    modalManager.dismiss()
                    guard !isCancelled else { return }
                    viewModel.setToken(token)
                    Task { await refreshViewModel() }
                }
            }
        }
        .alert("Refresh Failed", isPresented: .constant(modalManager.refreshError != nil), presenting: modalManager.refreshError) { error in
            Button("OK") { modalManager.setRefreshError(nil) }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private func refreshViewModel() async {
        do {
            try await viewModel.refresh()
            router.handlePendingDeepLink(DeepLinkManager.shared)
        } catch {
            modalManager.setRefreshError(error)
        }
    }
}

private struct RepositoryItemView: View {
    private let viewModel: RepositoryItemViewModel
    
    init(viewModel: RepositoryItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(viewModel.name)
                    .font(.body.bold())
                    .foregroundColor(.primary)
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .accessibility(hidden: true)
                Text(viewModel.starCount)
                    .font(.caption.monospaced())
                    .foregroundColor(.secondary)
            }
            Text(viewModel.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
/*
#Preview {
    // Mock sample data
    // *** Comment line to preview: "try await viewModel.refresh()"
    class PreviewAPI: GitHubAPIProviding {
        func fetchRepositories(from owner: GitHubOwner) async throws -> [GitHubMinimalRepository] { [] }
        func fetchRepository(with fullName: String) async throws -> GitHubFullRepository { throw NSError(domain: "", code: 0, userInfo: nil) }
    }
    let viewModel = RepositoriesViewModel(api: PreviewAPI())
    viewModel.title = "swiftlang"
    viewModel.repositories = [
        RepositoryItemViewModel(name: "swift", fullName: "swiftlang/swift", description: "The Swift Programming Language", starCount: "68,742"),
        RepositoryItemViewModel(name: "swift-llbuild", fullName: "swiftlang/swift-llbuild", description: "A low-level build system, used by Xcode and the Swift Package Manager", starCount: "1,218"),
        RepositoryItemViewModel(name: "swift-package-manager", fullName: "swiftlang/swift-package-manager", description: "The Package Manager for the Swift Programming Language", starCount: "9,946")
    ]
    return RepositoriesView(viewModel, NavigationRouter())
}
*/
