import SwiftUI

struct StatStrip: View {
    let launches: [Launch]
    @EnvironmentObject var lang: LanguageStore

    private var lsp: LaunchProvider? {
        launches.compactMap { $0.lsp }
            .first { ($0.totalLaunchCount ?? 0) > 0 }
    }

    private var boosterStats: BoosterStats {
        StatsCalculator.calculateBoosterStats(launches: launches)
    }

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 140), spacing: 12)]
        LazyVGrid(columns: columns, spacing: 12) {
            stat(
                value: "\(lsp?.totalLaunchCount.map(String.init) ?? "—")",
                label: lang.t("stat_launches"),
                sub: lang.t("stat_since"),
                accent: Palette.accent
            )
            stat(
                value: "\(lsp?.successfulLandings.map(String.init) ?? "—")",
                label: lang.t("stat_landings"),
                sub: lang.t("stat_inrow", ["n": "\(lsp?.consecutiveSuccessfulLandings ?? 0)"]),
                accent: Palette.go
            )
            stat(
                value: "\(boosterStats.fleetLeaderFlights)×",
                label: lang.t("stat_reuse"),
                sub: lang.t("stat_reuse_sub", ["s": boosterStats.fleetLeader ?? "—"]),
                accent: Palette.ss
            )
            stat(
                value: "\(lsp?.consecutiveSuccessfulLaunches.map(String.init) ?? "—")",
                label: lang.t("stat_consec"),
                sub: lang.t("stat_consec_sub"),
                accent: Palette.accent2
            )
            stat(
                value: boosterStats.turnaroundDays > 0 ? "\(boosterStats.turnaroundDays)j" : "—",
                label: lang.t("stat_turn"),
                sub: lang.t("stat_turn_sub") + (boosterStats.turnaroundBooster.map { " (\($0))" } ?? ""),
                accent: Palette.accent
            )
            stat(
                value: "\(launches.count)",
                label: lang.t("stat_upcoming"),
                sub: lang.t("stat_upcoming_sub"),
                accent: Palette.fh
            )
        }
    }

    private func stat(value: String, label: String, sub: String, accent: Color) -> some View {
        HStack(spacing: 0) {
            Rectangle().fill(accent).frame(width: 3)
            VStack(alignment: .leading, spacing: 6) {
                Text(value)
                    .font(Font2.mono(22, weight: .semibold))
                    .foregroundColor(Palette.text)
                    .lineLimit(1)
                Text(label.uppercased())
                    .font(Font2.mono(9, weight: .medium))
                    .tracking(1.2)
                    .foregroundColor(Palette.faint)
                    .lineLimit(1)
                Text(sub)
                    .font(Font2.mono(10))
                    .foregroundColor(Palette.muted)
                    .lineLimit(1)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .panel(radius: 14)
    }
}
