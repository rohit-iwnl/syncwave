import SwiftUI
import NavigationTransitions

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding: Bool = false
    @StateObject private var appUserStateManager = AppUserManger()
    @State private var isLoading = true
    @State private var showError = false
    @State private var hasCompletedPreferences = false
    @State private var isContentReady = false
    
    var checkResetToHome : Bool = false
    
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @State private var hasCheckedSession = false // New state variable
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
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
                                WelcomeCard(navigationCoordinator: navigationCoordinator)
                                    .environmentObject(appUserStateManager)
                                    .ignoresSafeArea(edges: .all)
                            }
                        } else {
                            if hasCompletedOnboarding {
                                SignInView()
                                    .environmentObject(self.navigationCoordinator)
                            } else {
                                OnboardingView()
                            }
                        }
                    }
                    .transition(.opacity)
                }
            }
            .navigationDestination(for: NavigationDestinations.self) { destination in
                
                switch destination {
                    
                case .welcome:
                    WelcomeCard(navigationCoordinator: navigationCoordinator)
                        .environmentObject(appUserStateManager)
                        .toolbar(.hidden)
                    
                case .preferences:
                    PreferencesView(navigationCoordinator: navigationCoordinator)
                        .toolbar(.hidden)
                        .environmentObject(appUserStateManager)
                    
                case .personalInfo:
                    PersonalInfoView(currentPage: $navigationCoordinator.currentPage, preferencesArray: $navigationCoordinator.preferencesArray)
                        .toolbar(.hidden)
                        .environmentObject(navigationCoordinator)
                    
                case .home:
                    HomeView()
                        .environmentObject(appUserStateManager)
                    
                case .signUp:
                    SignupSheet(emailID: "")
                        .environmentObject(appUserStateManager)
                case .housing:
                    HousingPreferencesView(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, isShowingHousingPreferences: .constant(true))
                        .environmentObject(navigationCoordinator)
                        .toolbar(.hidden)
                default:
                    Text("Unknown destination :\(destination)")
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isContentReady)
            .onAppear {
                if !hasCheckedSession { // Check if session has been checked
                    checkSession()
                    hasCheckedSession = true // Set to true after checking session
                }
            }
            .environmentObject(appUserStateManager)
        }
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
                            
                            // Navigate based on preferences completion
                            if preferencesCompleted {
                                navigationCoordinator.path.append(NavigationDestinations.home)
                            } else {
                                navigationCoordinator.path.append(NavigationDestinations.welcome)
                            }
                        }
                    }
                } else {
                    await MainActor.run {
                        withAnimation {
                            self.appUserStateManager.appUser = nil
                            self.isLoading = false
                            self.isContentReady = true
                            
                            // Navigate to onboarding or sign-in based on onboarding completion
                            if hasCompletedOnboarding {
                                navigationCoordinator.path.append(NavigationDestinations.signIn)
                            } else {
                                navigationCoordinator.path.append(NavigationDestinations.onboarding)
                            }
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
                        
                        // Handle error by navigating to an error view or similar handling
                    }
                }
            }
        }
    }
}
