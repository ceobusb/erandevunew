import SwiftUI

@main
struct ErandevuAppApp: App {
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
