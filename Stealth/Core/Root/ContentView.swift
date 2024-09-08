import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding: Bool = false
    @StateObject private var appUserStateManager = AppUserManger()
    @State private var isLoading = true
    @State private var showError = false
    @State private var hasCompletedPreferences = false
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading...")
                    .transition(.opacity)
            } else if let appUser = appUserStateManager.appUser, !appUser.uid.isEmpty {
                if hasCompletedPreferences {
                    HomeView()
                        .transition(.opacity)
                } else {
                    PreferencesView()
                        .transition(.opacity)
                }
            } else if !hasCompletedOnboarding {
                OnboardingView()
                    .transition(.opacity)
            } else {
                SignInView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appUserStateManager.appUser)
        .animation(.easeInOut(duration: 0.5), value: hasCompletedPreferences)
        .animation(.easeInOut(duration: 0.5), value: isLoading)
        .onAppear(perform: checkOnboardingAndSession)
        .alert("Session Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to retrieve your session. Please try signing in again.")
        }
        .environmentObject(appUserStateManager)
    }
    
    private func checkOnboardingAndSession() {
        // Check if onboarding is completed first
        if !hasCompletedOnboarding {
            withAnimation {
                isLoading = false
            }
            return
        }
        
        // If onboarding is completed, check the session
        Task {
            do {
                let sessionUser = try await AuthManager.shared.getCurrentSession()
                
                // Check if user has completed preferences
                let preferencesCompleted = await PreferencesService.shared.checkIfUserCompletedPreferences(userID: sessionUser.uid)
                
                await MainActor.run {
                    withAnimation {
                        self.appUserStateManager.appUser = sessionUser
                        self.hasCompletedPreferences = preferencesCompleted
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to get current session: \(error.localizedDescription)")
                await MainActor.run {
                    withAnimation {
                        self.showError = true
                        self.isLoading = false
                    }
                }
            }
        }
    }
}
