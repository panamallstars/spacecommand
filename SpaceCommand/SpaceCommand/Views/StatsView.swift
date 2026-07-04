import SwiftUI

struct StatsView: View {
    let launches: [Launch]
    @EnvironmentObject var lang: LanguageStore
    @Environment(\.dismiss) var dismiss

    private var lsp: LaunchProvider? {
        launches.compactMap { $0.lsp }
            .first { ($0.totalLaunchCount ?? 0) > 0 }
    }

    private var boosterStats: BoosterStats {
        StatsCalculator.calculateBoosterStats(launches: launches)
    }

    private var starlinksCount: Int {
        launches.filter { $0.name.contains("Starlink") }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero
                    VStack(alignment: .leading, spacing: 12) {
                        Text("// Mission analytics · statistiques globales".uppercased())
                            .font(Font2.mono(9, weight: .medium))
                            .tracking(1.2)
                            .foregroundColor(Palette.faint)
                        Text("Statistiques\nSpaceX")
                            .font(Font2.orbitron(36, weight: .heavy))
                            .foregroundColor(Palette.text)
                        Text("Vue d'ensemble des performances de SpaceX : lancements, taux de réussite, records de la flotte et tendances du programme spatial.")
                            .font(Font2.body(14))
                            .foregroundColor(Palette.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 20)

                    // Stats Grid
                    let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]
                    let successRate = lsp.flatMap { ls in
                        ls.successfulLandings.flatMap { sf in
                            ls.totalLaunchCount.map { Int(Double(sf) / Double($0) * 100) }
                        }
                    }
                    LazyVGrid(columns: columns, spacing: 12) {
                        statCard(
                            value: (lsp?.totalLaunchCount).map(String.init) ?? "—",
                            unit: "vols",
                            label: "LANCEMENTS SPACEX",
                            detail: "depuis 2006",
                            highlight: true
                        )
                        statCard(
                            value: successRate.map(String.init) ?? "—",
                            unit: "%",
                            label: "TAUX DE SUCCÈS",
                            detail: lsp.flatMap { ls in
                                ls.successfulLandings.flatMap { sf in
                                    ls.totalLaunchCount.map { "\(sf) / \($0) réussis" }
                                }
                            } ?? "données indisponibles",
                            highlight: false
                        )
                        statCard(
                            value: "\(boosterStats.fleetLeaderFlights)",
                            unit: "vols",
                            label: "RECORD FALCON 9",
                            detail: "Booster \(boosterStats.fleetLeader ?? "—")",
                            highlight: true
                        )
                        statCard(
                            value: boosterStats.turnaroundDays > 0 ? "\(boosterStats.turnaroundDays)" : "—",
                            unit: boosterStats.turnaroundDays > 0 ? "jours" : "",
                            label: "RECORD TURNAROUND",
                            detail: "Booster \(boosterStats.turnaroundBooster ?? "—")",
                            highlight: false
                        )
                        statCard(
                            value: "\(starlinksCount)",
                            unit: "missions",
                            label: "STARLINK LANCÉS",
                            detail: "\(starlinksCount) réussites confirmées",
                            highlight: true
                        )
                        statCard(
                            value: "628",
                            unit: "récupérés",
                            label: "LANDINGS BOOSTERS",
                            detail: "628 / 641 tentatives (98%)",
                            highlight: true
                        )
                        statCard(
                            value: "55",
                            unit: "refactorisés",
                            label: "BOOSTERS RÉUTILISÉS",
                            detail: "volé au moins 2 fois",
                            highlight: false
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Statistiques")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Palette.muted)
                            .font(.title3)
                    }
                }
            }
        }
    }

    private func statCard(value: String, unit: String, label: String, detail: String, highlight: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(Font2.mono(9, weight: .medium))
                .tracking(1.2)
                .foregroundColor(Palette.faint)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(Font2.mono(32, weight: .heavy))
                    .foregroundColor(highlight ? Palette.accent : Palette.text)
                Text(unit)
                    .font(Font2.mono(12))
                    .foregroundColor(Palette.muted)
            }
            Text(detail)
                .font(Font2.mono(10))
                .foregroundColor(Palette.muted)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Palette.panel.opacity(0.7))
        .border(highlight ? Palette.accent : Palette.stroke, width: 1)
        .cornerRadius(14)
    }
}
