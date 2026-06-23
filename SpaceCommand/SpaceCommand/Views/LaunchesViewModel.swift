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

    private var loadTask: Task<Void, Never>?

    init() {
        // Load bootstrap data immediately
        let sorted = BootstrapData.launches.sorted { ($0.net ?? .distantFuture) < ($1.net ?? .distantFuture) }
        state = .loaded(sorted)

        // Try to fetch fresh data in background
        Task {
            do {
                let launches = try await APIClient.shared.upcomingLaunches()
                state = .loaded(launches.sorted { ($0.net ?? .distantFuture) < ($1.net ?? .distantFuture) })
            } catch {
                // Keep bootstrap data on error, don't show error state
            }
        }
    }

    func load() async {
        loadTask?.cancel()
        state = .loading

        loadTask = Task {
            do {
                let launches = try await APIClient.shared.upcomingLaunches()
                if !Task.isCancelled {
                    state = .loaded(launches.sorted { ($0.net ?? .distantFuture) < ($1.net ?? .distantFuture) })
                }
            } catch {
                if !Task.isCancelled {
                    state = .error
                }
            }
        }
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
