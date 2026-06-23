import SwiftUI

struct NextLaunchHero: View {
    let launch: Launch
    @EnvironmentObject var lang: LanguageStore

    var body: some View {
        ZStack {
            AsyncImage(url: launch.heroImageURL) { phase in
                if case .success(let img) = phase {
                    img.resizable().scaledToFill()
                        .opacity(0.30)
                } else {
                    RadialGradient(
                        colors: [Palette.familyColor(launch.family).opacity(0.35), .clear],
                        center: .topLeading, startRadius: 5, endRadius: 400
                    )
                }
            }
            .overlay(
                LinearGradient(
                    colors: [Palette.bg.opacity(0.96), Palette.bg.opacity(0.55)],
                    startPoint: .leading, endPoint: .trailing
                )
            )

            VStack(alignment: .leading, spacing: 12) {
                Text(lang.t("next_launch"))
                    .font(Font2.mono(10, weight: .semibold))
                    .tracking(2.4)
                    .foregroundColor(Palette.accent)

                Text(launch.name)
                    .font(Font2.orbitron(24, weight: .bold))
                    .foregroundColor(Palette.text)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 12) {
                    metaLabel(icon: "fuelpump.fill", text: launch.rocket?.configuration?.name ?? launch.family.label)
                    if let pad = launch.pad?.name {
                        metaLabel(icon: "location.fill", text: pad)
                    }
                }
                .font(Font2.mono(11))
                .foregroundColor(Palette.muted)

                CountdownView(date: launch.net)
                    .environmentObject(lang)
                    .padding(.top, 6)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 240)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Palette.strokeStrong, lineWidth: 0.5)
        )
    }

    private func metaLabel(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 10))
            Text(text)
        }
    }
}
