import SwiftUI

struct MissionDetailView: View {
    let launch: Launch
    @EnvironmentObject var lang: LanguageStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var notifications = NotificationService.shared
    @State private var boosterHistory: [LauncherHistoryItem]?
    @State private var loadingHistory = false
    @State private var wiki: WikiSummary?
    @State private var wikiLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                hero
                missionSection
                if let stage = launch.rocket?.launcherStage?.first {
                    boosterSection(stage: stage)
                } else {
                    noBooster
                }
                wikipediaSection
                linksSection
            }
            .padding(.horizontal, 18)
            .padding(.top, 0)
            .padding(.bottom, 120)
        }
        .background(StarsBackground().ignoresSafeArea())
        .scrollIndicators(.hidden)
        .overlay(alignment: .topTrailing) {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Palette.text)
                    .padding(10)
                    .background(.black.opacity(0.55))
                    .overlay(Circle().stroke(Palette.strokeStrong, lineWidth: 0.5))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.top, 18)
            .padding(.trailing, 18)
        }
        .overlay(alignment: .bottom) {
            notifyBar
        }
        .task {
            await loadWiki()
            if let serial = launch.rocket?.launcherStage?.first?.launcher?.serialNumber {
                await loadBoosterHistory(serial: serial)
            }
        }
        .onChange(of: lang.current) { _, _ in
            Task { await loadWiki() }
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: launch.heroImageURL) { phase in
                if case .success(let img) = phase {
                    img.resizable().scaledToFill()
                } else {
                    RadialGradient(
                        colors: [Palette.familyColor(launch.family).opacity(0.35), .clear],
                        center: .center, startRadius: 5, endRadius: 200
                    )
                }
            }
            .frame(height: 240)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [.clear, Palette.bg],
                    startPoint: .top, endPoint: .bottom
                )
            )

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    chip(launch.family.shortLabel, color: Palette.familyColor(launch.family))
                    if let flightNumber = launch.rocket?.launcherStage?.first?.launcherFlightNumber {
                        Text(lang.t("flight_n", ["n": "\(flightNumber)"]))
                            .font(Font2.mono(11, weight: .semibold))
                            .foregroundColor(Palette.accent)
                    }
                }
                Text(launch.name)
                    .font(Font2.orbitron(24, weight: .bold))
                    .foregroundColor(Palette.text)
                Text(launch.rocket?.configuration?.name ?? launch.family.label)
                    .font(Font2.mono(11))
                    .foregroundColor(Palette.muted)
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Palette.strokeStrong, lineWidth: 0.5)
        )
        .padding(.top, 8)
    }

    private var missionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle(lang.t("m_mission"))
            if let desc = launch.mission?.description, !desc.isEmpty {
                Text(desc)
                    .font(Font2.body(14))
                    .foregroundColor(Color(red: 0.769, green: 0.824, blue: 0.925))
                    .lineSpacing(3)
            }
            CountdownView(date: launch.net).environmentObject(lang)

            sectionTitle(lang.t("m_keyfacts"))
            keyFactsGrid
        }
    }

    private var keyFactsGrid: some View {
        let cols = [GridItem(.adaptive(minimum: 140), spacing: 10)]
        return LazyVGrid(columns: cols, spacing: 10) {
            keyFact(lang.t("if_liftoff"), formattedDate(launch.net))
            keyFact(lang.t("if_status"), launch.status?.name ?? "—", color: Palette.statusColor(launch.status?.kind ?? .unknown))
            keyFact(lang.t("if_rocket"), launch.rocket?.configuration?.fullName ?? launch.family.label)
            if let orbit = launch.mission?.orbit?.name {
                keyFact(lang.t("if_orbit"), orbit)
            }
            if let type = launch.mission?.type {
                keyFact(lang.t("if_mtype"), type)
            }
            if let pad = launch.pad?.name {
                keyFact(lang.t("if_pad"), pad)
            }
            if let site = launch.pad?.location?.name {
                keyFact(lang.t("if_site"), site)
            }
        }
    }

    private func boosterSection(stage: LauncherStage) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle(lang.t("m_boosters"))
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(stage.launcher?.serialNumber ?? "—")
                        .font(Font2.orbitron(20, weight: .bold))
                        .foregroundColor(Palette.text)
                    Spacer()
                    Text(stage.reused == true ? lang.t("b_reused") : lang.t("b_firstflight"))
                        .font(Font2.mono(9, weight: .semibold))
                        .tracking(1.2)
                        .foregroundColor(stage.reused == true ? Palette.go : Palette.accent)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(stage.reused == true ? Palette.go : Palette.accent, lineWidth: 1)
                        )
                }
                let cols = [GridItem(.adaptive(minimum: 90), spacing: 8)]
                LazyVGrid(columns: cols, spacing: 8) {
                    statCell("\(stage.launcher?.flights ?? 0)", lang.t("b_total"))
                    statCell("\(stage.launcher?.successfulLandings ?? 0)", lang.t("b_landings"))
                    statCell("\(stage.launcher?.attemptedLandings ?? 0)", lang.t("b_attempts"))
                    if let t = stage.turnAroundTimeDays {
                        statCell("\(t)\(lang.t("dayunit"))", lang.t("b_turn"))
                    }
                }
                if let first = stage.launcher?.firstLaunchDate, let last = stage.launcher?.lastLaunchDate {
                    HStack {
                        smallFact(lang.t("b_firstdate"), shortDate(first))
                        Spacer()
                        smallFact(lang.t("b_lastdate"), shortDate(last))
                    }
                }
                if let history = boosterHistory, !history.isEmpty {
                    historyTimeline(history)
                } else if loadingHistory {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                            .progressViewStyle(CircularProgressViewStyle(tint: Palette.accent))
                        Text("…").foregroundColor(Palette.muted)
                    }
                    .font(Font2.body(13))
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Palette.accent.opacity(0.06), Palette.accent2.opacity(0.05)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(Palette.strokeStrong, lineWidth: 0.5)
            )
        }
    }

    private var noBooster: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle(lang.t("m_boosters"))
            Text(lang.t("b_nodata"))
                .font(Font2.body(13))
                .foregroundColor(Palette.muted)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .panel(radius: 14)
        }
    }

    private func historyTimeline(_ items: [LauncherHistoryItem]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(items.prefix(10).enumerated()), id: \.element.id) { idx, item in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .stroke(item.status?.kind == .hold ? Palette.hold : Palette.go, lineWidth: 1.5)
                        .frame(width: 8, height: 8)
                        .padding(.top, 5)
                    Text("#\(items.count - idx)")
                        .font(Font2.mono(10, weight: .semibold))
                        .foregroundColor(Palette.accent)
                        .frame(width: 30, alignment: .leading)
                    Text(item.name)
                        .font(Font2.body(12))
                        .foregroundColor(Color(red: 0.86, green: 0.90, blue: 0.98))
                        .lineLimit(1)
                    Spacer()
                    if let date = item.net {
                        Text(shortDate(date))
                            .font(Font2.mono(10))
                            .foregroundColor(Palette.faint)
                    }
                }
            }
        }
        .padding(.top, 8)
    }

    private var wikipediaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(lang.t("m_wikicontext"))
            if let wiki, let extract = wiki.extract, !extract.isEmpty {
                HStack(alignment: .top, spacing: 12) {
                    if let url = wiki.thumbnail?.source {
                        AsyncImage(url: url) { phase in
                            if case .success(let img) = phase {
                                img.resizable().scaledToFill()
                            } else {
                                Color.black.opacity(0.3)
                            }
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(extract)
                            .font(Font2.body(13))
                            .foregroundColor(Color(red: 0.769, green: 0.824, blue: 0.925))
                            .lineLimit(6)
                        if let url = wiki.contentUrls?.desktop?.page {
                            Link(destination: url) {
                                Label(lang.t("wiki_read_on"), systemImage: "book")
                                    .font(Font2.body(12, weight: .semibold))
                                    .foregroundColor(Palette.accent)
                            }
                        }
                    }
                }
                .padding(14)
                .panel(radius: 14)
            } else if wikiLoading {
                HStack(spacing: 10) {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Palette.accent))
                    Text(lang.t("wiki_loading"))
                        .font(Font2.body(12))
                        .foregroundColor(Palette.muted)
                }.padding(14).panel(radius: 14)
            }
        }
    }

    private var linksSection: some View {
        Group {
            if let vid = launch.vidUrls?.first?.url {
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle(lang.t("m_links"))
                    Link(destination: vid) {
                        Label(lang.t("webcast"), systemImage: "play.tv")
                            .font(Font2.body(13, weight: .semibold))
                            .foregroundColor(Color(red: 0.812, green: 0.878, blue: 0.984))
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Color.white.opacity(0.03))
                            .overlay(RoundedRectangle(cornerRadius: 11).stroke(Palette.stroke, lineWidth: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                    }
                }
            }
        }
    }

    private var notifyBar: some View {
        let scheduled = notifications.isScheduled(launch.id)
        return HStack(spacing: 10) {
            Button {
                Task {
                    if scheduled {
                        notifications.cancel(launchID: launch.id)
                    } else {
                        _ = await notifications.schedule(launch: launch)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: scheduled ? "bell.badge.fill" : "bell.fill")
                    Text(scheduled ? lang.t("notify_cancel") : lang.t("notify_on"))
                        .font(Font2.body(13, weight: .semibold))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AccentGradient())
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(launch.net == nil)
            .opacity(launch.net == nil ? 0.5 : 1)

            ShareLink(item: shareText) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Palette.text)
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.04))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Palette.stroke, lineWidth: 0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 24)
        .background(
            LinearGradient(
                colors: [.clear, Palette.bg.opacity(0.95)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .padding(.bottom, -60)
            , alignment: .bottom
        )
    }

    private var shareText: String {
        var s = "\(lang.t("app_name")) · \(launch.name)"
        if let date = launch.net {
            s += "\n" + formattedDate(date)
        }
        return s
    }

    private func sectionTitle(_ title: String) -> some View {
        HStack(spacing: 10) {
            Text(title.uppercased())
                .font(Font2.mono(10, weight: .semibold))
                .tracking(2.4)
                .foregroundColor(Palette.accent)
            Rectangle().fill(Palette.stroke).frame(height: 1).frame(maxWidth: .infinity)
        }
    }

    private func keyFact(_ label: String, _ value: String, color: Color = Palette.text) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label.uppercased())
                .font(Font2.mono(9, weight: .medium))
                .tracking(1.2)
                .foregroundColor(Palette.faint)
            Text(value)
                .font(Font2.mono(13, weight: .semibold))
                .foregroundColor(color)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.03))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func statCell(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(Font2.mono(18, weight: .semibold))
                .foregroundColor(Palette.text)
            Text(label.uppercased())
                .font(Font2.mono(8))
                .tracking(1.2)
                .foregroundColor(Palette.faint)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.4))
        .overlay(RoundedRectangle(cornerRadius: 11).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 11))
    }

    private func smallFact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(Font2.mono(9)).tracking(1).foregroundColor(Palette.faint)
            Text(value).font(Font2.mono(11, weight: .semibold)).foregroundColor(Palette.text)
        }
    }

    private func chip(_ text: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(text).font(Font2.mono(10, weight: .semibold)).foregroundColor(Palette.text)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(.black.opacity(0.55))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return lang.t("date_tbd") }
        MissionDetailView.longFmt.locale = Locale(identifier: lang.current == .fr ? "fr_FR" : "en_GB")
        return MissionDetailView.longFmt.string(from: date)
    }

    private func shortDate(_ date: Date) -> String {
        MissionDetailView.shortFmt.locale = Locale(identifier: lang.current == .fr ? "fr_FR" : "en_GB")
        return MissionDetailView.shortFmt.string(from: date)
    }

    private static let longFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .short
        return f
    }()

    private static let shortFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f
    }()

    @MainActor
    private func loadBoosterHistory(serial: String) async {
        loadingHistory = true
        defer { loadingHistory = false }
        boosterHistory = (try? await APIClient.shared.boosterHistory(serial: serial)) ?? []
    }

    @MainActor
    private func loadWiki() async {
        wikiLoading = true
        defer { wikiLoading = false }
        let title = MissionDetailView.wikiTitle(for: launch.name, lang: lang.current)
        wiki = await WikipediaService.shared.summary(title: title, language: lang.current.rawValue)
    }

    private static func wikiTitle(for missionName: String, lang: AppLanguage) -> String {
        let n = missionName.lowercased()
        if n.contains("starlink") { return "Starlink" }
        if n.contains("crew") { return "Crew Dragon" }
        if n.contains("dragon") || n.contains("crs") || n.contains("cargo") { return "SpaceX Dragon 2" }
        if n.contains("nrol") || n.contains("starshield") { return "National Reconnaissance Office" }
        if n.contains("transporter") || n.contains("rideshare") || n.contains("bandwagon") { return "SpaceX Transporter" }
        if n.contains("galileo") {
            return lang == .fr ? "Galileo (système de positionnement)" : "Galileo (satellite navigation)"
        }
        if n.contains("o3b") || n.contains("mpower") { return "O3b mPOWER" }
        if n.contains("starship") { return "SpaceX Starship" }
        if n.contains("falcon heavy") { return "Falcon Heavy" }
        if n.contains("falcon") { return "Falcon 9" }
        return missionName
            .replacingOccurrences(of: "|", with: " ")
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
