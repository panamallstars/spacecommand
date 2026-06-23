import SwiftUI
import UserNotifications

struct AlertsView: View {
    @EnvironmentObject var lang: LanguageStore
    @StateObject private var notifications = NotificationService.shared
    @State private var pending: [PendingItem] = []

    struct PendingItem: Identifiable, Hashable {
        let id: String
        let title: String
        let date: Date?
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    if pending.isEmpty {
                        emptyState
                    } else {
                        list
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .padding(.bottom, 120)
            }
            .background(StarsBackground())
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) { BrandMark() }
            }
            .toolbarBackground(Palette.bg.opacity(0.85), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { await refresh() }
            .refreshable { await refresh() }
        }
        .tint(Palette.accent)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lang.t("alerts_kicker")).font(Font2.mono(10, weight: .semibold)).tracking(2.8).foregroundColor(Palette.accent)
            Text(lang.t("alerts_title"))
                .font(Font2.orbitron(28, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.624, green: 0.851, blue: 1.0), Palette.accent2],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bell.slash")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(Palette.muted)
            Text(lang.t("alerts_empty"))
                .font(Font2.orbitron(15, weight: .semibold))
                .foregroundColor(Palette.text)
            Text(lang.t("alerts_empty_sub"))
                .font(Font2.body(13))
                .foregroundColor(Palette.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .panel(radius: 18)
    }

    private var list: some View {
        VStack(spacing: 10) {
            ForEach(pending) { item in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "bell.badge.fill")
                        .foregroundStyle(AccentGradient.style)
                        .font(.system(size: 16))
                        .padding(.top, 2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(Font2.orbitron(14, weight: .semibold))
                            .foregroundColor(Palette.text)
                        if let date = item.date {
                            Text("T-1h · \(shortDate(date))")
                                .font(Font2.mono(11))
                                .foregroundColor(Palette.muted)
                        }
                    }
                    Spacer()
                    Button {
                        notifications.cancel(launchID: item.id.replacingOccurrences(of: "launch.", with: ""))
                        Task { await refresh() }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Palette.muted)
                            .padding(8)
                            .background(Color.white.opacity(0.04))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(14)
                .panel(radius: 14)
            }
        }
    }

    private func shortDate(_ d: Date) -> String {
        AlertsView.formatter.locale = Locale(identifier: lang.current == .fr ? "fr_FR" : "en_GB")
        return AlertsView.formatter.string(from: d)
    }

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE d MMM · HH:mm"
        return f
    }()

    @MainActor
    private func refresh() async {
        let center = UNUserNotificationCenter.current()
        let requests = await center.pendingNotificationRequests()
        pending = requests.compactMap { req in
            let date: Date? = (req.trigger as? UNCalendarNotificationTrigger).flatMap {
                Calendar.current.date(from: $0.dateComponents)
            }
            return PendingItem(id: req.identifier, title: req.content.title, date: date)
        }
        .sorted { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) }
    }
}
