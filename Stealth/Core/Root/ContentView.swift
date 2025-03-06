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
    @State private var hasCheckedSession = false
    
    @StateObject private var globalState = GlobalStateManager()
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            ZStack {
                if isLoading {
//                    ProgressView(label: {
//                        Text("Loading")
//                    })
                } else if isContentReady {
                    Group {
                        if let appUser = appUserStateManager.appUser, let uid = appUser.uid, !uid.isEmpty, uid != "" {
                            if hasCompletedPreferences {
                                HomeView()
                                    .toolbar(.hidden)
                                    .environmentObject(appUserStateManager)
                                    .environmentObject(navigationCoordinator)
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
                    .transition(.move(edge: .trailing))
                }
            }
            .navigationDestination(for: NavigationDestinations.self) { destination in
                
                switch destination {
                    
                case .welcome:
                    WelcomeCard(navigationCoordinator: navigationCoordinator)
                        .environmentObject(appUserStateManager)
                        .toolbar(.hidden)
                    
                case .preferences:
                    PreferencesView()
                        .toolbar(.hidden)
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                    
                case .personalInfo:
                    PersonalInfoView(currentPage: $navigationCoordinator.currentPage, preferencesArray: $navigationCoordinator.preferencesArray)
                        .toolbar(.hidden)
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                    
                case .home:
                    HomeView()
                        .toolbar(.hidden)
                        .environmentObject(appUserStateManager)
                        .environmentObject(navigationCoordinator)
                case .signIn:
                    SignInView()
                        .environmentObject(appUserStateManager)
                case .signUp:
                    SignupSheet(emailID: "")
                        .environmentObject(appUserStateManager)
                case .housing:
                    HousingPreferencesView(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, isShowingHousingPreferences: .constant(true))
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                        .toolbar(.hidden)
                case .roomdecider:
                    RoomDeciderView()
                        .toolbar(.hidden)
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                case .sellingProperty:
                    LeasingView()
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                        .toolbar(.hidden)
                case .lookingForRoommate:
                    BasicInfoView(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages)
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                        .toolbar(.hidden)
                case .personalTraitsFirstScreen:
                    PersonalTraitFirstView(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages)
                        .environmentObject(navigationCoordinator)
                        .environmentObject(appUserStateManager)
                        .toolbar(.hidden)
                case .roomplan:
                    RoomTestView()
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
            .environmentObject(globalState)
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
                            DispatchQueue.main.asyncAfter(deadline: .now()){
                                if preferencesCompleted {
                                    navigationCoordinator.path.append(NavigationDestinations.home)
                                } else {
                                    navigationCoordinator.path.append(NavigationDestinations.welcome)
                                }
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
                            DispatchQueue.main.asyncAfter(deadline: .now()){
                                if hasCompletedOnboarding {
                                    navigationCoordinator.path.append(NavigationDestinations.signIn)
                                } else {
                                    navigationCoordinator.path.append(NavigationDestinations.onboarding)
                                }
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
