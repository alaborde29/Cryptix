import SwiftUI

@main
struct CryptixApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.dependencies, DependencyContainer.shared)
                .preferredColorScheme(.light)
        }
    }
}
