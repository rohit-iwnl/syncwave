import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageConstants.hasCompletedOnboarding.key) private var hasCompletedOnboarding: Bool = false
    @State private var appUser: AppUser? = nil
    @State private var isLoading = true
    @State private var showError = false
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if let appUser = appUser, !appUser.uid.isEmpty {
                HomeView(appUser: $appUser)
                    .transition(.move(edge: .trailing))
            } else {
                SignInView(appUser: $appUser)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appUser)
        .onAppear(perform: checkSession)
        .alert("Session Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to retrieve your session. Please try signing in again.")
        }
    }
    
    private func checkSession() {
        Task {
            do {
                let sessionUser = try await AuthManager.shared.getCurrentSession()
                await MainActor.run {
                    withAnimation {
                        self.appUser = sessionUser
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to get current session: \(error.localizedDescription)")
                await MainActor.run {
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
