import SwiftUI

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: kIsLoggedIn)

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                Home()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                Onboarding(isLoggedIn: $isLoggedIn)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
