import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var lang: LanguageStore
    @StateObject private var notifications = NotificationService.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    section(lang.t("settings_lang")) {
                        HStack(spacing: 8) {
                            ForEach(AppLanguage.allCases) { l in
                                Button {
                                    lang.set(l)
                                } label: {
                                    Text(l == .fr ? "Français" : "English")
                                        .font(Font2.body(14, weight: .semibold))
                                        .foregroundColor(lang.current == l ? .black : Palette.text)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            Group {
                                                if lang.current == l {
                                                    AccentGradient()
                                                } else {
                                                    Color.white.opacity(0.04)
                                                }
                                            }
                                        )
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.stroke, lineWidth: 0.5))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    section(lang.t("settings_notif")) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: notifications.authorization == .authorized ? "bell.badge.fill" : "bell.slash")
                                    .foregroundColor(notifications.authorization == .authorized ? Palette.go : Palette.muted)
                                Text(notificationStatusText)
                                    .font(Font2.body(13))
                                    .foregroundColor(Palette.text)
                                Spacer()
                            }
                            if notifications.authorization == .denied {
                                Button {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    Text(lang.t("set_open_settings"))
                                        .font(Font2.body(13, weight: .semibold))
                                        .foregroundColor(Palette.accent)
                                }
                            } else if notifications.authorization != .authorized {
                                Button {
                                    Task { _ = await notifications.requestAuthorizationIfNeeded() }
                                } label: {
                                    Text(lang.t("set_enable_notif"))
                                        .font(Font2.body(13, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 14).padding(.vertical, 9)
                                        .background(AccentGradient())
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                            if !notifications.scheduledIDs.isEmpty {
                                Button {
                                    notifications.cancelAll()
                                } label: {
                                    Text(lang.t("set_cancel_all", ["n": "\(notifications.scheduledIDs.count)"]))
                                        .font(Font2.body(12, weight: .semibold))
                                        .foregroundColor(Palette.hold)
                                }
                            }
                        }
                    }

                    section(lang.t("support_title")) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(lang.t("support_desc"))
                                .font(Font2.body(13))
                                .foregroundColor(Palette.muted)
                                .fixedSize(horizontal: false, vertical: true)
                            Link(destination: URL(string: "https://buymeacoffee.com/spacecommand")!) {
                                HStack(spacing: 8) {
                                    Text("☕")
                                    Text(lang.t("support_btn"))
                                        .font(Font2.body(14, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [Palette.tbd, Palette.fh],
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    section(lang.t("settings_about")) {
                        VStack(alignment: .leading, spacing: 10) {
                            row(lang.t("settings_version"), Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            Text(lang.t("settings_data"))
                                .font(Font2.body(12)).foregroundColor(Palette.muted)
                            Text(lang.t("settings_summaries"))
                                .font(Font2.body(12)).foregroundColor(Palette.muted)
                            Text(lang.t("settings_disclaim"))
                                .font(Font2.body(11)).foregroundColor(Palette.faint).padding(.top, 4)
                        }
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
                ToolbarItem(placement: .topBarTrailing) { LangToggle() }
            }
            .toolbarBackground(Palette.bg.opacity(0.85), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { await notifications.refreshAuthorization() }
        }
        .tint(Palette.accent)
    }

    private var notificationStatusText: String {
        switch notifications.authorization {
        case .authorized: return lang.t("set_notif_on")
        case .denied: return lang.t("set_notif_off")
        case .provisional, .ephemeral: return lang.t("set_notif_prov")
        default: return lang.t("set_notif_none")
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(title.uppercased())
                    .font(Font2.mono(10, weight: .semibold))
                    .tracking(2.2)
                    .foregroundColor(Palette.accent)
                Rectangle().fill(Palette.stroke).frame(height: 1).frame(maxWidth: .infinity)
            }
            content()
                .padding(16)
                .panel(radius: 16)
        }
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(Font2.body(13)).foregroundColor(Palette.muted)
            Spacer()
            Text(value).font(Font2.mono(13, weight: .semibold)).foregroundColor(Palette.text)
        }
    }
}
