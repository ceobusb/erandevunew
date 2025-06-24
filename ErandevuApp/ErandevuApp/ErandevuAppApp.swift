import SwiftUI

@main
struct ErandevuAppApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)  // BURADA MUTLAKA EKLE
        }
    }
}

