import SwiftUI

@main
struct SpaceCommandApp: App {
    @StateObject private var lang = LanguageStore()
    @StateObject private var notifications = NotificationService.shared

    init() {
        configureNavigationBar()
        configureTabBar()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(lang)
                .environmentObject(notifications)
                .preferredColorScheme(.dark)
                .environment(\.locale, Locale(identifier: lang.current.rawValue))
        }
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.020, green: 0.027, blue: 0.051, alpha: 0.85)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.08)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(red: 0.055, green: 0.075, blue: 0.125, alpha: 0.85)
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterialDark)
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.08)

        let accent = UIColor(red: 0.227, green: 0.839, blue: 1.0, alpha: 1.0)
        let muted = UIColor(red: 0.337, green: 0.400, blue: 0.522, alpha: 1.0)

        let configure = { (item: UITabBarItemAppearance) in
            item.normal.iconColor = muted
            item.normal.titleTextAttributes = [
                .foregroundColor: muted,
                .font: UIFont.monospacedSystemFont(ofSize: 10, weight: .medium)
            ]
            item.selected.iconColor = accent
            item.selected.titleTextAttributes = [
                .foregroundColor: accent,
                .font: UIFont.monospacedSystemFont(ofSize: 10, weight: .semibold)
            ]
        }
        configure(appearance.stackedLayoutAppearance)
        configure(appearance.inlineLayoutAppearance)
        configure(appearance.compactInlineLayoutAppearance)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct RootView: View {
    @EnvironmentObject var lang: LanguageStore
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            PadRoot()
        } else {
            PhoneRoot()
        }
    }
}

struct PhoneRoot: View {
    @EnvironmentObject var lang: LanguageStore
    @State private var selection: Tab = .launches

    enum Tab: Hashable { case launches, encyclopedia, alerts, settings }

    var body: some View {
        TabView(selection: $selection) {
            LaunchesView()
                .tabItem {
                    Label(lang.t("tab_launches"), systemImage: "paperplane.fill")
                }
                .tag(Tab.launches)

            EncyclopediaView()
                .tabItem {
                    Label(lang.t("tab_ency"), systemImage: "book.fill")
                }
                .tag(Tab.encyclopedia)

            AlertsView()
                .tabItem {
                    Label(lang.t("tab_alerts"), systemImage: "bell.fill")
                }
                .tag(Tab.alerts)

            SettingsView()
                .tabItem {
                    Label(lang.t("tab_settings"), systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .tint(Palette.accent)
    }
}

struct PadRoot: View {
    @EnvironmentObject var lang: LanguageStore
    @State private var selection: PhoneRoot.Tab? = .launches

    var body: some View {
        NavigationSplitView {
            sidebar
                .navigationTitle("Space Command")
                .toolbarBackground(Palette.bg.opacity(0.9), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .background(StarsBackground())
        } detail: {
            detailView
        }
        .tint(Palette.accent)
        .navigationSplitViewStyle(.balanced)
    }

    private var sidebar: some View {
        List(selection: $selection) {
            sidebarRow(.launches, icon: "paperplane.fill", label: lang.t("tab_launches"))
            sidebarRow(.encyclopedia, icon: "book.fill", label: lang.t("tab_ency"))
            sidebarRow(.alerts, icon: "bell.fill", label: lang.t("tab_alerts"))
            sidebarRow(.settings, icon: "gearshape.fill", label: lang.t("tab_settings"))
        }
        .scrollContentBackground(.hidden)
        .background(Palette.bg)
        .listStyle(.sidebar)
    }

    private func sidebarRow(_ tab: PhoneRoot.Tab, icon: String, label: String) -> some View {
        Label {
            Text(label).font(Font2.body(15, weight: .medium))
        } icon: {
            Image(systemName: icon).foregroundColor(Palette.accent)
        }
        .tag(tab)
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection ?? .launches {
        case .launches: LaunchesView()
        case .encyclopedia: EncyclopediaView()
        case .alerts: AlertsView()
        case .settings: SettingsView()
        }
    }
}
