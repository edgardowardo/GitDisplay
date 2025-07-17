import Foundation
import Security


public protocol TokenManagerProviding {
    func getToken() -> String?
    func saveToken(_ token: String)
}

public final class TokenManager: TokenManagerProviding {
    public init() {}

    private let tokenKey = "GitHubAPIToken"

    public func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data, let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    public func saveToken(_ token: String) {
        let tokenData = token.data(using: .utf8) ?? Data()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]

        // Delete any existing item
        SecItemDelete(query as CFDictionary)

        // Add new item
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: tokenData
        ]

        SecItemAdd(attributes as CFDictionary, nil)
    }
}

