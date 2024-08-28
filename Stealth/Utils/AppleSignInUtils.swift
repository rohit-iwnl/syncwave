//
//  AppleSignInUtils.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/26/24.
//

import Foundation
import CryptoKit
import AuthenticationServices

struct SignInWithAppleResult {
    let idToken : String
    let nonce : String
}


class AppleSignInUtils : NSObject {
    
    
    fileprivate var currentNonce: String?
    
    private var completionHandler :((Result<SignInWithAppleResult, Error>) -> Void)?
    
    func startSignInWithAppleFlow() async throws -> SignInWithAppleResult {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.startSignInWithAppleFlow { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func startSignInWithAppleFlow(completion : @escaping (((Result<SignInWithAppleResult, Error>) -> Void))) {
        
        guard let topVC = UIApplication.shared.topViewController() else {
            completion(.failure(NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to find top view controller."])))
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleSignInUtils : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor(frame: .zero)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let completion = completionHandler else {
            // Log the error or handle it gracefully
            print("Invalid state: A login callback was received, but no login request was sent.")
            completionHandler?(.failure(NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid state during Apple Sign-In."])))
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            completion(.failure(NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token."])))
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            completion(.failure(NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token string."])))
            return
        }
        
        let appleResult = SignInWithAppleResult(idToken: idTokenString, nonce: nonce)
        completion(.success(appleResult))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error.localizedDescription)")
        
        // Call the completion handler to resume the async task with failure
        completionHandler?(.failure(error))
    }

}

extension UIViewController : @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


//extension UIApplication {
//    
//    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        
//        if let nav = base as? UINavigationController {
//            return getTopViewController(base: nav.visibleViewController)
//            
//        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return getTopViewController(base: selected)
//            
//        } else if let presented = base?.presentedViewController {
//            return getTopViewController(base: presented)
//        }
//        return base
//    }
//}
extension UIApplication {
    func topViewController() -> UIViewController? {
        // Ensure the method is executed on the main thread
        if !Thread.isMainThread {
            return DispatchQueue.main.sync {
                return self.topViewController()
            }
        }

        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        
        return topViewController
    }
}


