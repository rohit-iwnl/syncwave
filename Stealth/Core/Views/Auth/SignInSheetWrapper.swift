//
//  SignInSheetWrapper.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/8/24.
//



import SwiftUI
import UIKit

struct SignInSheetWrapper: UIViewControllerRepresentable {
    @EnvironmentObject private var appUserStateManager: AppUserManger
    
    func makeUIViewController(context: Context) -> UIViewController {
        let hostingController = UIHostingController(rootView: SignInView())
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
