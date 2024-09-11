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
                                .ignoresSafeArea(edges: .all)
                        }
                    } else {
                        SignInView() // Only show this if no session exists
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isContentReady)
        .onAppear(perform: checkSession)
        .alert("Session Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to retrieve your session. Please try signing in again.")
        }
        .environmentObject(appUserStateManager)
    }
    
    private func checkSession() {
        Task {
            await MainActor.run {
                isLoading = true
                isContentReady = false
            }
            
            // Skip onboarding, check session directly
            do {
                // Attempt to retrieve the current session
                let sessionUser = try await AuthManager.shared.getCurrentSession()
                
                // Check if the user has completed preferences
                let preferencesCompleted = await PreferencesService.shared.checkIfUserCompletedPreferences(userID: sessionUser.uid)
                
                // Simulate short delay for smoother transition
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
