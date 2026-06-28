import SwiftUI

struct RecentLaunchesView: View {
    let launches: [Launch]
    @EnvironmentObject var lang: LanguageStore
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero
                    VStack(alignment: .leading, spacing: 12) {
                        Text("// Mission history · derniers vols".uppercased())
                            .font(Font2.mono(9, weight: .medium))
                            .tracking(1.2)
                            .foregroundColor(Palette.faint)
                        Text("Récemment\nlancé")
                            .font(Font2.display(36, weight: .heavy))
                            .foregroundColor(Palette.text)
                        Text("Historique des dernières missions SpaceX : Falcon 9, Falcon Heavy et Starship. Explorez les résultats et performances de chaque vol.")
                            .font(Font2.body)
                            .foregroundColor(Palette.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 20)

                    // Recent launches grid
                    let cols = [GridItem(.adaptive(minimum: 160), spacing: 12)]
                    LazyVGrid(columns: cols, spacing: 12) {
                        ForEach(launches) { launch in
                            recentCard(launch)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Récemment lancé")
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

    private func recentCard(_ launch: Launch) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(launch.name ?? "Unknown")
                .font(Font2.orbitron(12, weight: .semibold))
                .foregroundColor(Palette.text)
                .lineLimit(2)

            let family = getRocketFamily(launch.rocket?.configuration?.name ?? "")
            HStack(spacing: 6) {
                Circle().fill(family.color).frame(width: 6, height: 6)
                Text(family.label)
                    .font(Font2.mono(9, weight: .medium))
                    .foregroundColor(family.color)
            }

            if let status = launch.status?.name {
                Text(status)
                    .font(Font2.mono(9))
                    .foregroundColor(statusColor(status))
                    .lineLimit(1)
            }

            if let net = launch.net {
                let dateStr = formatDate(net)
                Text(dateStr)
                    .font(Font2.mono(8))
                    .foregroundColor(Palette.muted)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(Palette.panel.withAlphaComponent(0.7)))
        .border(Palette.stroke, width: 1)
        .cornerRadius(12)
    }

    private func getRocketFamily(_ name: String) -> (label: String, color: Color) {
        if name.lowercased().contains("heavy") {
            return ("Falcon Heavy", Palette.fh)
        } else if name.lowercased().contains("starship") || name.lowercased().contains("super heavy") {
            return ("Starship", Palette.ss)
        } else if name.lowercased().contains("falcon 9") {
            return ("Falcon 9", Palette.f9)
        }
        return ("Other", Palette.muted)
    }

    private func statusColor(_ status: String) -> Color {
        let lower = status.lowercased()
        if lower.contains("success") {
            return Palette.go
        } else if lower.contains("hold") || lower.contains("fail") {
            return Palette.hold
        } else if lower.contains("tbd") || lower.contains("tbc") {
            return Palette.tbd
        }
        return Palette.muted
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}
