import SwiftUI

@main
struct ErandevuAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState()
    @State private var selectedTab: Int = 0

    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: $selectedTab)

                .environmentObject(appState)
        }
    }
}
