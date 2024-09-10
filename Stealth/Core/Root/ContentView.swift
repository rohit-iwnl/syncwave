import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding: Bool = false
    @StateObject private var appUserStateManager = AppUserManger()
    @State private var isLoading = true
    @State private var showError = false
    @State private var hasCompletedPreferences = false
    @State private var isContentReady = false
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading...")
                    .transition(.opacity)
            } else if isContentReady {
                Group {
                    if let appUser = appUserStateManager.appUser, !appUser.uid.isEmpty {
                        if hasCompletedPreferences {
                            HomeView()
                                .environmentObject(appUserStateManager)
                        } else {
                            WelcomeCard()
                                .environmentObject(appUserStateManager)
                        }
                    } else if !hasCompletedOnboarding {
                        OnboardingView()
                    } else {
                        SignInView()
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isContentReady)
        .onAppear(perform: checkOnboardingAndSession)
        .alert("Session Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to retrieve your session. Please try signing in again.")
        }
        .environmentObject(appUserStateManager)
    }
    
    private func checkOnboardingAndSession() {
        Task {
            await MainActor.run {
                isLoading = true
                isContentReady = false
            }
            
            // Check if onboarding is completed first
            if !hasCompletedOnboarding {
                try? await Task.sleep(for: .milliseconds(500))
                await MainActor.run {
                    withAnimation {
                        isLoading = false
                        isContentReady = true
                    }
                }
                return
            }
            
            // If onboarding is completed, check the session
            do {
                let sessionUser = try await AuthManager.shared.getCurrentSession()
                let preferencesCompleted = await PreferencesService.shared.checkIfUserCompletedPreferences(userID: sessionUser.uid)
                
                try? await Task.sleep(for: .milliseconds(100))
                
                await MainActor.run {
                    withAnimation {
                        self.appUserStateManager.appUser = sessionUser
                        self.hasCompletedPreferences = preferencesCompleted
                        self.isLoading = false
                        self.isContentReady = true
                    }
                }
            } catch {
                print("Failed to get current session: \(error.localizedDescription)")
                
                try? await Task.sleep(for: .milliseconds(100))
                
                await MainActor.run {
                    withAnimation {
                        self.showError = true
                        self.isLoading = false
                        self.isContentReady = true
                    }
                }
            }
        }
    }
    
}

