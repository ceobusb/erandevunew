import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack(path: $appState.path) {
            if !appState.isLoggedIn {
                ContentView()
            } else if !appState.isEmailVerified {
                if let email = appState.userEmail {
                    EmailVerificationView(email: email)
                        .environmentObject(appState)
                } else {
                    ContentView()
                    
                }
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }

    }
}
