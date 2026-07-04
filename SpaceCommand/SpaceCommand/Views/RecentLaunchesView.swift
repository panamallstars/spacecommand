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
                            .font(Font2.orbitron(36, weight: .heavy))
                            .foregroundColor(Palette.text)
                        Text("Historique des dernières missions SpaceX : Falcon 9, Falcon Heavy et Starship. Explorez les résultats et performances de chaque vol.")
                            .font(Font2.body(14))
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
        ZStack(alignment: .bottomLeading) {
            // Background image
            if let imageUrl = launch.image?.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color(Palette.panel)
                }
                .opacity(0.22)
                .ignoresSafeArea()
            }

            // Gradient veil
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.055, green: 0.074, blue: 0.125).opacity(0.96),
                    Color(red: 0.055, green: 0.074, blue: 0.125).opacity(0.5)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 6) {
                // Status
                HStack(spacing: 4) {
                    let status = launch.status?.name ?? ""
                    let isSuccess = status.lowercased().contains("success")
                    let isFailed = status.lowercased().contains("fail")

                    Text(isSuccess ? "✓" : isFailed ? "✗" : "○")
                        .font(Font2.mono(10, weight: .bold))
                        .foregroundColor(isSuccess ? Palette.go : isFailed ? Palette.hold : Palette.muted)

                    Text(launch.status?.abbrev ?? "")
                        .font(Font2.mono(7, weight: .bold))
                        .tracking(0.5)
                        .foregroundColor(isSuccess ? Palette.go : isFailed ? Palette.hold : Palette.muted)
                }
                .lineLimit(1)

                // Mission name
                Text(launch.mission?.name ?? launch.name)
                    .font(Font2.orbitron(11, weight: .semibold))
                    .foregroundColor(Palette.text)
                    .lineLimit(2)

                // Rocket family & date
                HStack(spacing: 8) {
                    let family = getRocketFamily(launch.rocket?.configuration?.name ?? "")
                    HStack(spacing: 4) {
                        Text("●")
                            .font(Font2.mono(8))
                            .foregroundColor(family.color)
                        Text(family.label)
                            .font(Font2.mono(7, weight: .medium))
                            .foregroundColor(family.color)
                    }

                    if let net = launch.net {
                        Text(formatDate(net))
                            .font(Font2.mono(7))
                            .foregroundColor(Palette.muted)
                    }
                }
                .lineLimit(1)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 110)
        .background(Color(Palette.panel))
        .border(Palette.stroke, width: 1)
        .cornerRadius(14)
        .clipped()
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
