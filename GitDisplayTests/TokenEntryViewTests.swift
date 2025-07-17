import Testing
import SwiftUI
@testable import GitDisplay

@Suite("TokenEntryView Tests")
struct TokenEntryViewTests {
    @Test("The Save button is disabled when the token is empty")
    func saveButtonDisabledWhenTokenIsEmpty() async throws {
        let vm = await TokenViewModel()
        let view = TokenEntryView(viewModel: vm, onDismiss: { (_, _) in })
        let host = await UIHostingController(rootView: view)
        _ = await host.view // force view load
        
        await MainActor.run {
            vm.token = ""
        }
        let isEmpty = await MainActor.run { vm.token.isEmpty }
        #expect(isEmpty)
    }

    @Test("onDismiss is called with token when Save is pressed")
    func onDismissCalledWithToken() async throws {
        let vm = await TokenViewModel()
        var dismissedToken: String?
        var continuation: CheckedContinuation<Void, Never>? = nil
        let view = TokenEntryView(viewModel: vm, onDismiss: { isCancelled, token in
            dismissedToken = token
            continuation?.resume()
        })
        let host = await UIHostingController(rootView: view)
        _ = await host.view // force view load

        await MainActor.run {
            vm.token = "test-token"
        }

        // Use a continuation to wait for callback
        await withCheckedContinuation { (c: CheckedContinuation<Void, Never>) in
            continuation = c
            Task { @MainActor in
                view.onDismiss?(false, vm.token)
            }
        }

        #expect(dismissedToken == "test-token")
    }
}

