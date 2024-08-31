//
//  StatusBarExtension.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/30/24.
//


import SwiftUI

class StatusBarController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
}

struct StatusBarStyleModifier: ViewModifier {
    @Binding var style: UIStatusBarStyle
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                updateStatusBarStyle(style)
            }
            .onChange(of: style) { _, newStyle in
                updateStatusBarStyle(newStyle)
            }
    }
    
    private func updateStatusBarStyle(_ style: UIStatusBarStyle) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let statusBarController = windowScene.windows.first?.rootViewController as? StatusBarController else {
            return
        }
        statusBarController.statusBarStyle = style
    }
}

extension View {
    func customStatusBarStyle(_ style: Binding<UIStatusBarStyle>) -> some View {
        modifier(StatusBarStyleModifier(style: style))
    }
}
