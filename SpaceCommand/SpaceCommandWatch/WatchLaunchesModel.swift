import Foundation
import SwiftUI

@MainActor
final class WatchLaunchesModel: ObservableObject {
    @Published var launches: [Launch] = []
    @Published var lastUpdated: Date?
    @Published var isStale = false
    @Published var isLoading = false

    init() {
        launches = Self.upcoming(BootstrapData.launches)
        Task { await refresh() }
    }

    var next: Launch? { launches.first }

    func refresh(force: Bool = false) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let feed = try await APIClient.shared.upcomingLaunches(forceRefresh: force)
            launches = Self.upcoming(feed.launches)
            lastUpdated = feed.updatedAt
            isStale = feed.isStale
        } catch {
            // Keep bootstrap/cached data on failure
            isStale = true
        }
    }

    /// Sorted by date, keeping only launches still relevant
    /// (future, TBD, or within the 3 h "in progress" window).
    private static func upcoming(_ list: [Launch]) -> [Launch] {
        let cutoff = Date().addingTimeInterval(-10800)
        return list
            .filter { $0.net.map { $0 > cutoff } ?? true }
            .sorted { ($0.net ?? .distantFuture) < ($1.net ?? .distantFuture) }
    }
}
