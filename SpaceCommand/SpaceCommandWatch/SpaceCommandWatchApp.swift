import SwiftUI

@main
struct SpaceCommandWatchApp: App {
    @StateObject private var model = WatchLaunchesModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WatchHomeView()
            }
            .environmentObject(model)
        }
    }
}
