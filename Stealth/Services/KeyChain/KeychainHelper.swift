import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    // Save a value to the Keychain
    func save(_ value: String, forKey key: String) -> Bool {
        let data = value.data(using: .utf8)!
        
        // Create a query to store the item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete the existing item if it exists (ignore the result)
        SecItemDelete(query as CFDictionary)
        
        // Add item to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Return whether saving was successful
        return status == errSecSuccess
    }

    // Retrieve a value from the Keychain
    func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // Check if the item exists and retrieve it
        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        } else if status == errSecItemNotFound {
            print("Item not found in Keychain for key: \(key)")
        } else {
            print("Error retrieving item for key: \(key), status: \(status)")
        }
        return nil
    }

    // Delete a value from the Keychain
    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Item deleted successfully for key: \(key)")
            return true
        } else if status == errSecItemNotFound {
            print("No item found to delete for key: \(key)")
        } else {
            print("Error deleting item for key: \(key), status: \(status)")
        }
        return false
    }
}
