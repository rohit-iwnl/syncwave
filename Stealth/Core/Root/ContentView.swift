import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding: Bool = false
    @State private var appUser: AppUser? = nil
    @State private var isLoading = true
    @State private var showError = false
    @State private var hasCompletedPreferences = false
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading...")
                    .transition(.opacity)
            } else if let appUser = appUser, !appUser.uid.isEmpty {
                if hasCompletedPreferences {
                    HomeView(appUser: $appUser)
                        .transition(.opacity)
                } else {
                    PreferencesView(appUser: $appUser)
                        .transition(.opacity)
                }
            } else if !hasCompletedOnboarding {
                OnboardingView(appUser: $appUser)
                    .transition(.opacity)
            } else {
                SignInView(appUser: $appUser)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appUser)
        .animation(.easeInOut(duration: 0.5), value: hasCompletedPreferences)
        .animation(.easeInOut(duration: 0.5), value: isLoading)
        .onAppear(perform: checkOnboardingAndSession)
        .alert("Session Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to retrieve your session. Please try signing in again.")
        }
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
                        self.appUser = sessionUser
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
