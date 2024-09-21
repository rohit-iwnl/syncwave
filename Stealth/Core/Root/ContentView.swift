import SwiftUI
import NavigationTransitions

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
                    if let appUser = appUserStateManager.appUser, let uid = appUser.uid, !uid.isEmpty {
                        if hasCompletedPreferences {
                            HomeView()
                                .toolbar(.hidden)
                                .environmentObject(appUserStateManager)
                        } else {
                            WelcomeCard()
                                .environmentObject(appUserStateManager)
                                .ignoresSafeArea(edges: .all)
                        }
                    } else {
                        if hasCompletedOnboarding {
                            SignInView()
                        } else {
                            OnboardingView()
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isContentReady)
        .onAppear(perform: checkSession)
        .environmentObject(appUserStateManager)
        
        
    }
    
    private func checkSession() {
        Task {
            await MainActor.run {
                isLoading = true
                isContentReady = false
            }
            
            do {
                if let sessionUser = try await AuthManager.shared.getCurrentSession() {
                    let preferencesCompleted = await PreferencesService.shared.checkIfUserCompletedPreferences(userID: sessionUser.uid ?? "")
                    
                    await MainActor.run {
                        withAnimation {
                            self.appUserStateManager.appUser = sessionUser
                            self.hasCompletedPreferences = preferencesCompleted
                            self.isLoading = false
                            self.isContentReady = true
                        }
                    }
                } else {
                    await MainActor.run {
                        withAnimation {
                            self.appUserStateManager.appUser = nil
                            self.isLoading = false
                            self.isContentReady = true
                        }
                    }
                }
            } catch {
                print("Failed to get current session: \(error.localizedDescription)")
                
                await MainActor.run {
                    withAnimation {
                        self.appUserStateManager.appUser = nil
                        self.isLoading = false
                        self.isContentReady = true
                        self.showError = true
                    }
                }
            }
        }
    }
}
