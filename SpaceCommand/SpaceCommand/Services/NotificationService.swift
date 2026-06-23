import Foundation
import UserNotifications
import SwiftUI

@MainActor
final class NotificationService: ObservableObject {
    static let shared = NotificationService()

    private static let bodyFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    @AppStorage("scheduled_launches") private var scheduledRaw: String = "[]"
    @Published private(set) var scheduledIDs: Set<String> = []
    @Published var authorization: UNAuthorizationStatus = .notDetermined

    init() {
        loadScheduled()
        Task { await refreshAuthorization() }
    }

    func refreshAuthorization() async {
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        self.authorization = status
    }

    func requestAuthorizationIfNeeded() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied:
            return false
        default:
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
            await refreshAuthorization()
            return granted
        }
    }

    func isScheduled(_ id: String) -> Bool {
        scheduledIDs.contains(id)
    }

    func schedule(launch: Launch, leadTime: TimeInterval = 3600) async -> Bool {
        guard let net = launch.net else { return false }
        let triggerDate = net.addingTimeInterval(-leadTime)
        guard triggerDate > Date() else { return false }
        let ok = await requestAuthorizationIfNeeded()
        guard ok else { return false }

        let content = UNMutableNotificationContent()
        content.title = "T-1h · \(launch.name)"
        if let rocket = launch.rocket?.configuration?.name {
            content.subtitle = rocket
        }
        content.body = NotificationService.bodyFmt.string(from: net)
        content.sound = .default
        content.threadIdentifier = "launch.\(launch.id)"

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "launch.\(launch.id)", content: content, trigger: trigger)

        do {
            try await UNUserNotificationCenter.current().add(request)
            scheduledIDs.insert(launch.id)
            persist()
            return true
        } catch {
            return false
        }
    }

    func cancel(launchID: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["launch.\(launchID)"])
        scheduledIDs.remove(launchID)
        persist()
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduledIDs.removeAll()
        persist()
    }

    private func loadScheduled() {
        guard let data = scheduledRaw.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: data) else {
            scheduledIDs = []
            return
        }
        scheduledIDs = Set(array)
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(Array(scheduledIDs)),
           let str = String(data: data, encoding: .utf8) {
            scheduledRaw = str
        }
    }
}
