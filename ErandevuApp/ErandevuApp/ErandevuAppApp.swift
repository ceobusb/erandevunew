import SwiftUI

@main
struct ErandevuAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var selectedTab: Int = 0

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                RootView(selectedTab: $selectedTab)
                    .environmentObject(appState)
            } else {
                OnboardingView()
            }
        }
    }
}
