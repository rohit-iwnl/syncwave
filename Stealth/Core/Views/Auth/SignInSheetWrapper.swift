//
//  SignInSheetWrapper.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/8/24.
//



import SwiftUI
import UIKit

struct SignInSheetWrapper: UIViewControllerRepresentable {
    @Binding var appUser: AppUser?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let hostingController = UIHostingController(rootView: SignInView(appUser: $appUser))
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

