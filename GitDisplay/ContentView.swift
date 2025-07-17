//
//  ContentView.swift
//  GitDisplay
//
//  Created by EDGARDO AGNO on 16/07/2025.
//

import SwiftUI
import GitHubAPI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    private let tokenManager: TokenManagerProviding
    @StateObject private var viewModel: RepositoriesViewModel
    
    init() {
        let tokenManager = TokenManager()
        self.tokenManager = tokenManager
        let api = GitHubAPI(authorisationToken: tokenManager.getToken())
        _viewModel = StateObject(wrappedValue: RepositoriesViewModel(api: api, tokenManager: tokenManager))
    }
    
    var body: some View {
        RepositoriesView(viewModel, router, tokenManager)
    }
}

#Preview {
    ContentView()
}
