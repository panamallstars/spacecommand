import SwiftUI

struct EncyclopediaView: View {
    @EnvironmentObject var lang: LanguageStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    section(
                        title: lang.t("ency_inservice"),
                        sub: lang.t("ency_inservice_sub"),
                        rockets: RocketCatalog.inService
                    )
                    boostersSection
                    crewDragonSection
                    cargoDragonSection
                    section(
                        title: lang.t("ency_retired"),
                        sub: lang.t("ency_retired_sub"),
                        rockets: RocketCatalog.retired
                    )
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
        }
        .tint(Palette.accent)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(lang.t("e_kicker"))
                .font(Font2.mono(10, weight: .semibold))
                .tracking(2.8)
                .foregroundColor(Palette.accent)
            Text(lang.t("e_title"))
                .font(Font2.orbitron(32, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.624, green: 0.851, blue: 1.0), Palette.accent2],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
            Text(lang.t("e_sub"))
                .font(Font2.body(14))
                .foregroundColor(Palette.muted)
        }
    }

    private var boostersSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(lang.t("ency_boosters"))
                    .font(Font2.orbitron(18, weight: .bold))
                    .foregroundColor(Palette.text)
                Text("// " + lang.t("ency_boosters_sub"))
                    .font(Font2.body(12))
                    .foregroundColor(Palette.muted)
                Rectangle().fill(Palette.stroke).frame(height: 1).frame(maxWidth: .infinity)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], spacing: 10) {
                ForEach(RocketCatalog.activeBoosters) { booster in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(booster.serial)
                                .font(Font2.orbitron(16, weight: .bold))
                                .foregroundColor(Palette.text)
                            Spacer()
                            Text(booster.status)
                                .font(Font2.mono(8, weight: .semibold))
                                .tracking(1)
                                .foregroundColor(Palette.go)
                                .padding(.horizontal, 6).padding(.vertical, 3)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Palette.go.opacity(0.4), lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }

                        HStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(booster.flights)")
                                    .font(Font2.mono(18, weight: .bold))
                                    .foregroundColor(Palette.accent)
                                Text(lang.t("b_flights"))
                                    .font(Font2.mono(8))
                                    .foregroundColor(Palette.faint)
                                    .tracking(0.8)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(booster.landings)")
                                    .font(Font2.mono(18, weight: .bold))
                                    .foregroundColor(Palette.go)
                                Text(lang.t("b_land"))
                                    .font(Font2.mono(8))
                                    .foregroundColor(Palette.faint)
                                    .tracking(0.8)
                            }
                        }

                        Text(booster.notable)
                            .font(Font2.body(10))
                            .foregroundColor(Palette.muted)
                            .lineLimit(2)

                        HStack(spacing: 8) {
                            Text(lang.t("b_last_pad"))
                                .font(Font2.mono(7, weight: .semibold))
                                .tracking(0.8)
                                .foregroundColor(Palette.faint)
                            Text(booster.lastPad)
                                .font(Font2.mono(9, weight: .bold))
                                .foregroundColor(Palette.accent)
                        }
                        .padding(.top, 6)
                    }
                    .padding(12)
                    .panel(radius: 14)
                }
            }
        }
    }

    private var crewDragonSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(lang.t("ency_crewdragon"))
                    .font(Font2.orbitron(18, weight: .bold))
                    .foregroundColor(Palette.text)
                Text("// " + lang.t("ency_crewdragon_sub"))
                    .font(Font2.body(12))
                    .foregroundColor(Palette.muted)
                Rectangle().fill(Palette.stroke).frame(height: 1).frame(maxWidth: .infinity)
            }

            ForEach(RocketCatalog.crewDragons) { dragon in
                CrewDragonCard(dragon: dragon).environmentObject(lang)
            }
        }
    }

    private var cargoDragonSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(lang.t("ency_cargodragon"))
                    .font(Font2.orbitron(18, weight: .bold))
                    .foregroundColor(Palette.text)
                Text("// " + lang.t("ency_cargodragon_sub"))
                    .font(Font2.body(12))
                    .foregroundColor(Palette.muted)
                Rectangle().fill(Palette.stroke).frame(height: 1).frame(maxWidth: .infinity)
            }

            ForEach(RocketCatalog.cargoDragons) { dragon in
                CargoDragonCard(dragon: dragon).environmentObject(lang)
            }
        }
    }

    private func section(title: String, sub: String, rockets: [RocketReference]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(title)
                    .font(Font2.orbitron(18, weight: .bold))
                    .foregroundColor(Palette.text)
                Text("// " + sub)
                    .font(Font2.body(12))
                    .foregroundColor(Palette.muted)
                Rectangle().fill(Palette.stroke).frame(height: 1).frame(maxWidth: .infinity)
            }
            ForEach(rockets) { rocket in
                RocketRefCard(rocket: rocket).environmentObject(lang)
            }
        }
    }
}

struct RocketRefCard: View {
    let rocket: RocketReference
    @EnvironmentObject var lang: LanguageStore
    @State private var wiki: WikiSummary?
    @State private var loading = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: rocket.imageURL) { phase in
                    if case .success(let img) = phase {
                        img.resizable().scaledToFill()
                    } else {
                        Palette.bg2
                    }
                }
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.clear, Palette.panelSolid],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                HStack {
                    Text(rocket.inService ? "ACTIVE" : "RETIRED")
                        .font(Font2.mono(9, weight: .semibold))
                        .tracking(1.4)
                        .foregroundColor(rocket.inService ? Palette.go : Palette.hold)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(rocket.inService ? Palette.go : Palette.hold, lineWidth: 1)
                        )
                    Spacer()
                    Text(rocket.name)
                        .font(Font2.orbitron(22, weight: .bold))
                        .foregroundColor(Palette.text)
                }
                .padding(14)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(rocket.variant)
                    .font(Font2.mono(11))
                    .foregroundColor(Palette.accent)

                if !rocket.palmares.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(rocket.palmares, id: \.label) { item in
                            achievement(item)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                let cols = [GridItem(.adaptive(minimum: 100), spacing: 8)]
                LazyVGrid(columns: cols, spacing: 8) {
                    spec("HEIGHT", rocket.height)
                    spec("Ø", rocket.diameter)
                    spec("MASS", rocket.mass)
                    spec("LEO", rocket.payloadLEO)
                    spec("STAGES", rocket.stages)
                    spec("ENG.", rocket.engines)
                    spec("FIRST", rocket.firstFlight)
                    if let lastFlight = rocket.lastFlight {
                        spec("LAST", lastFlight)
                    }
                    spec("REUSE", rocket.reusable)
                }

                Divider().background(Palette.stroke)

                wikipediaInline
            }
            .padding(16)
        }
        .panel(radius: 20)
        .task { await loadWiki() }
        .onChange(of: lang.current) { _, _ in
            Task { await loadWiki() }
        }
    }

    private func achievement(_ item: RocketReference.Achievement) -> some View {
        let color = encyAchievementColor(item.kind)
        return Text(item.label)
            .font(Font2.mono(10))
            .foregroundColor(color)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color.white.opacity(0.03))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.4), lineWidth: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .lineLimit(1)
    }

    private func spec(_ label: String, _ value: String) -> some View {
        EncySpecCell(label: label, value: value)
    }

    private var wikipediaInline: some View {
        Group {
            if let wiki, let extract = wiki.extract {
                HStack(alignment: .top, spacing: 12) {
                    if let url = wiki.thumbnail?.source {
                        AsyncImage(url: url) { phase in
                            if case .success(let img) = phase {
                                img.resizable().scaledToFill()
                            } else { Color.black.opacity(0.3) }
                        }
                        .frame(width: 92, height: 92)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.stroke, lineWidth: 0.5))
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(extract)
                            .font(Font2.body(13))
                            .foregroundColor(Color(red: 0.769, green: 0.824, blue: 0.925))
                            .lineLimit(5)
                        if let page = wiki.contentUrls?.desktop?.page {
                            Link(destination: page) {
                                Label(lang.t("wiki_read_on"), systemImage: "book")
                                    .font(Font2.body(12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.812, green: 0.878, blue: 0.984))
                                    .padding(.horizontal, 12).padding(.vertical, 7)
                                    .background(Color.white.opacity(0.03))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Palette.stroke, lineWidth: 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
            } else if loading {
                HStack(spacing: 8) {
                    ProgressView().controlSize(.small)
                    Text(lang.t("wiki_loading")).font(Font2.body(12)).foregroundColor(Palette.muted)
                }
            }
        }
    }

    @MainActor
    private func loadWiki() async {
        loading = true
        defer { loading = false }
        wiki = await WikipediaService.shared.summary(title: rocket.wikipediaTitle, language: lang.current.rawValue)
    }
}

struct CrewDragonCard: View {
    let dragon: CrewDragonReference
    @EnvironmentObject var lang: LanguageStore
    @State private var wiki: WikiSummary?
    @State private var loading = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: dragon.imageURL) { phase in
                    if case .success(let img) = phase {
                        img.resizable().scaledToFill()
                    } else {
                        Palette.bg2
                    }
                }
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.clear, Palette.panelSolid],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                HStack {
                    Text("ACTIVE")
                        .font(Font2.mono(9, weight: .semibold))
                        .tracking(1.4)
                        .foregroundColor(Palette.go)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Palette.go, lineWidth: 1))
                    Spacer()
                    Text(dragon.name)
                        .font(Font2.orbitron(20, weight: .bold))
                        .foregroundColor(Palette.text)
                }
                .padding(14)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Text(dragon.serial)
                        .font(Font2.mono(11, weight: .semibold))
                        .foregroundColor(Palette.accent)
                    Text("·")
                        .foregroundColor(Palette.faint)
                    Text(dragon.variant)
                        .font(Font2.mono(11))
                        .foregroundColor(Palette.muted)
                }

                if !dragon.palmares.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(dragon.palmares, id: \.label) { item in
                            let color = encyAchievementColor(item.kind)
                            Text(item.label)
                                .font(Font2.mono(10))
                                .foregroundColor(color)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.white.opacity(0.03))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.4), lineWidth: 0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                let cols = [GridItem(.adaptive(minimum: 100), spacing: 8)]
                LazyVGrid(columns: cols, spacing: 8) {
                    EncySpecCell(label: lang.t("cd_missions"), value: "\(dragon.missions)")
                    EncySpecCell(label: lang.t("cd_crew"), value: dragon.crewCapacity)
                    EncySpecCell(label: lang.t("cd_status"), value: dragon.status)
                }

                let dateCols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: dateCols, spacing: 8) {
                    DragonDateCell(label: lang.t("cd_first_flight"), value: fmtDay(dragon.firstFlight))
                    DragonDateCell(label: lang.t("cd_last_flight"), value: fmtDay(dragon.lastFlight))
                    DragonDateCell(label: lang.t("cd_next_flight"), value: fmtDay(dragon.nextFlight))
                }

                if !dragon.flightHistory.isEmpty {
                    Divider().background(Palette.stroke)
                    DragonFlightHistory(flights: dragon.flightHistory)
                }

                if let wiki, let extract = wiki.extract {
                    Divider().background(Palette.stroke)
                    HStack(alignment: .top, spacing: 12) {
                        if let url = wiki.thumbnail?.source {
                            AsyncImage(url: url) { phase in
                                if case .success(let img) = phase {
                                    img.resizable().scaledToFill()
                                } else { Color.black.opacity(0.3) }
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Palette.stroke, lineWidth: 0.5))
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text(extract)
                                .font(Font2.body(12))
                                .foregroundColor(Color(red: 0.769, green: 0.824, blue: 0.925))
                                .lineLimit(4)
                            if let page = wiki.contentUrls?.desktop?.page {
                                Link(destination: page) {
                                    Label(lang.t("wiki_read_on"), systemImage: "book")
                                        .font(Font2.body(11, weight: .semibold))
                                        .foregroundColor(Color(red: 0.812, green: 0.878, blue: 0.984))
                                }
                            }
                        }
                    }
                } else if loading {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                        Text(lang.t("wiki_loading")).font(Font2.body(12)).foregroundColor(Palette.muted)
                    }
                }
            }
            .padding(14)
        }
        .panel(radius: 20)
        .task { await loadWiki() }
        .onChange(of: lang.current) { _, _ in
            Task { await loadWiki() }
        }
    }

    private func fmtDay(_ iso: String?) -> String {
        fmtDragonDate(iso, locale: lang.current)
    }

    @MainActor
    private func loadWiki() async {
        loading = true
        defer { loading = false }
        wiki = await WikipediaService.shared.summary(title: dragon.wikipediaTitle, language: lang.current.rawValue)
    }
}

private func fmtDragonDate(_ iso: String?, locale: AppLanguage) -> String {
    guard let iso else { return "—" }
    let parser = DateFormatter()
    parser.dateFormat = "yyyy-MM-dd"
    parser.locale = Locale(identifier: "en_US_POSIX")
    guard let d = parser.date(from: iso) else { return iso }
    let fmt = DateFormatter()
    fmt.dateStyle = .medium
    fmt.timeStyle = .none
    fmt.locale = Locale(identifier: locale == .fr ? "fr_FR" : "en_US")
    return fmt.string(from: d)
}

struct DragonFlightHistory: View {
    let flights: [DragonFlight]
    @EnvironmentObject var lang: LanguageStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("HISTORIQUE DES VOLS")
                .font(Font2.mono(9, weight: .semibold))
                .tracking(1.2)
                .foregroundColor(Palette.faint)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(flights, id: \.mission) { flight in
                    row(flight)
                }
            }
        }
    }

    private func row(_ flight: DragonFlight) -> some View {
        let ongoing = flight.landingDate == nil
        return HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(ongoing ? Palette.go : Palette.accent)
                .frame(width: 6, height: 6)
                .padding(.top, 5)
                .shadow(color: ongoing ? Palette.go.opacity(0.7) : .clear, radius: 3)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(flight.mission)
                        .font(Font2.body(12, weight: .semibold))
                        .foregroundColor(Palette.text)
                    if ongoing {
                        Text("EN COURS")
                            .font(Font2.mono(7, weight: .bold))
                            .tracking(0.6)
                            .foregroundColor(Palette.go)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Palette.go.opacity(0.5), lineWidth: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                Text(ongoing
                     ? fmtDragonDate(flight.launchDate, locale: lang.current) + " → —"
                     : "\(fmtDragonDate(flight.launchDate, locale: lang.current)) → \(fmtDragonDate(flight.landingDate, locale: lang.current))")
                    .font(Font2.mono(10))
                    .foregroundColor(Palette.muted)
                if !flight.crew.isEmpty {
                    Text(flight.crew.joined(separator: " · "))
                        .font(Font2.body(10))
                        .foregroundColor(Palette.faint)
                        .lineLimit(2)
                }
            }
        }
    }
}

private struct DragonDateCell: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(Font2.mono(7, weight: .medium))
                .tracking(1.0)
                .foregroundColor(Palette.faint)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(Font2.body(11, weight: .semibold))
                .foregroundColor(Palette.text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.black.opacity(0.3))
        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 9))
    }
}

struct CargoDragonCard: View {
    let dragon: CargoDragonReference
    @EnvironmentObject var lang: LanguageStore
    @State private var wiki: WikiSummary?
    @State private var loading = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Palette.bg2)
                    .frame(height: 90)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 34, weight: .light))
                            .foregroundColor(Palette.muted.opacity(0.35))
                    )
                HStack {
                    Text("ACTIVE")
                        .font(Font2.mono(9, weight: .semibold))
                        .tracking(1.4)
                        .foregroundColor(Palette.go)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Palette.go, lineWidth: 1))
                    Spacer()
                    Text(dragon.serial)
                        .font(Font2.orbitron(20, weight: .bold))
                        .foregroundColor(Palette.text)
                }
                .padding(14)
            }

            VStack(alignment: .leading, spacing: 12) {
                let cols = [GridItem(.adaptive(minimum: 100), spacing: 8)]
                LazyVGrid(columns: cols, spacing: 8) {
                    EncySpecCell(label: lang.t("cd_missions"), value: "\(dragon.missions)")
                    EncySpecCell(label: lang.t("cd_status"), value: dragon.status)
                }

                let dateCols = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: dateCols, spacing: 8) {
                    DragonDateCell(label: lang.t("cd_first_flight"), value: fmtDragonDate(dragon.firstFlight, locale: lang.current))
                    DragonDateCell(label: lang.t("cd_last_flight"), value: fmtDragonDate(dragon.flightHistory.last?.launchDate, locale: lang.current))
                }

                if !dragon.flightHistory.isEmpty {
                    Divider().background(Palette.stroke)
                    DragonFlightHistory(flights: dragon.flightHistory)
                }

                if let wiki, let extract = wiki.extract {
                    Divider().background(Palette.stroke)
                    HStack(alignment: .top, spacing: 12) {
                        if let url = wiki.thumbnail?.source {
                            AsyncImage(url: url) { phase in
                                if case .success(let img) = phase {
                                    img.resizable().scaledToFill()
                                } else { Color.black.opacity(0.3) }
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Palette.stroke, lineWidth: 0.5))
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text(extract)
                                .font(Font2.body(12))
                                .foregroundColor(Color(red: 0.769, green: 0.824, blue: 0.925))
                                .lineLimit(4)
                            if let page = wiki.contentUrls?.desktop?.page {
                                Link(destination: page) {
                                    Label(lang.t("wiki_read_on"), systemImage: "book")
                                        .font(Font2.body(11, weight: .semibold))
                                        .foregroundColor(Color(red: 0.812, green: 0.878, blue: 0.984))
                                }
                            }
                        }
                    }
                } else if loading {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                        Text(lang.t("wiki_loading")).font(Font2.body(12)).foregroundColor(Palette.muted)
                    }
                }
            }
            .padding(14)
        }
        .panel(radius: 20)
        .task { await loadWiki() }
        .onChange(of: lang.current) { _, _ in
            Task { await loadWiki() }
        }
    }

    @MainActor
    private func loadWiki() async {
        loading = true
        defer { loading = false }
        wiki = await WikipediaService.shared.summary(title: "SpaceX Dragon 2", language: lang.current.rawValue)
    }
}

private func encyAchievementColor(_ kind: RocketReference.Achievement.Kind) -> Color {
    switch kind {
    case .ok: return Palette.go
    case .ko: return Palette.hold
    case .neutral: return Color(red: 0.812, green: 0.878, blue: 0.984)
    }
}

private struct EncySpecCell: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(Font2.mono(8, weight: .medium))
                .tracking(1.2)
                .foregroundColor(Palette.faint)
            Text(value)
                .font(Font2.mono(12, weight: .semibold))
                .foregroundColor(Palette.text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.black.opacity(0.4))
        .overlay(RoundedRectangle(cornerRadius: 11).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 11))
    }
}
