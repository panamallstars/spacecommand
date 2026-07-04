import Foundation
import SwiftUI

@MainActor
final class LaunchesViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([Launch])
        case error
    }

    @Published var state: State = .loading
    @Published var filter: RocketFamily? = nil
    @Published var query: String = ""
    @Published var lastUpdated: Date?
    @Published var isStale = false
    @Published var isRefreshing = false

    private var loadTask: Task<Void, Never>?

    init() {
        // Show bootstrap data instantly, then refresh from network/cache in background
        state = .loaded(Self.upcoming(BootstrapData.launches))

        Task { await load() }
    }

    /// Sorted by date, keeping only launches still relevant
    /// (future, TBD, or within the 3 h "in progress" window).
    private static func upcoming(_ list: [Launch]) -> [Launch] {
        let cutoff = Date().addingTimeInterval(-10800)
        return list
            .filter { $0.net.map { $0 > cutoff } ?? true }
            .sorted { ($0.net ?? .distantFuture) < ($1.net ?? .distantFuture) }
    }

    /// Refreshes the launch list. Existing data stays on screen while
    /// the request is in flight; the error state only appears when there
    /// is nothing at all to show.
    func load(force: Bool = false) async {
        loadTask?.cancel()
        isRefreshing = true
        defer { isRefreshing = false }

        let task = Task {
            do {
                let feed = try await APIClient.shared.upcomingLaunches(forceRefresh: force)
                if !Task.isCancelled {
                    state = .loaded(Self.upcoming(feed.launches))
                    lastUpdated = feed.updatedAt
                    isStale = feed.isStale
                }
            } catch {
                if !Task.isCancelled {
                    // Keep whatever we already have; only surface the error screen
                    // when there is no data at all.
                    if launches.isEmpty {
                        state = .error
                    } else {
                        isStale = true
                    }
                }
            }
        }
        loadTask = task
        await task.value
    }

    var launches: [Launch] {
        if case .loaded(let list) = state { return list }
        return []
    }

    var next: Launch? { launches.first }

    func filtered() -> [Launch] {
        var list = launches
        if let filter {
            list = list.filter { $0.family == filter }
        }
        if !query.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = query.lowercased()
            list = list.filter {
                $0.name.lowercased().contains(q) ||
                ($0.pad?.name?.lowercased().contains(q) ?? false) ||
                ($0.pad?.location?.name?.lowercased().contains(q) ?? false) ||
                ($0.mission?.orbit?.name?.lowercased().contains(q) ?? false) ||
                ($0.mission?.type?.lowercased().contains(q) ?? false)
            }
        }
        return list
    }

    func counts() -> [RocketFamily: Int] {
        Dictionary(grouping: launches, by: { $0.family }).mapValues { $0.count }
    }
}
