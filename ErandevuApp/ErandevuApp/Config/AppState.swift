import SwiftUI

class AppState: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("isEmailVerified") var isEmailVerified: Bool = false
    @Published var userEmail: String? = nil  // email burada tutulabilir
    @Published var path = NavigationPath()
}
