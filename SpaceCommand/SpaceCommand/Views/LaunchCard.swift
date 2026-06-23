import SwiftUI

struct LaunchCard: View {
    let launch: Launch
    @EnvironmentObject var lang: LanguageStore

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: launch.heroImageURL) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    default:
                        familyBackdrop
                    }
                }
                .frame(height: 132)
                .frame(maxWidth: .infinity)
                .clipped()
                .opacity(0.55)
                .overlay(
                    LinearGradient(
                        colors: [.clear, Palette.panelSolid.opacity(0.95)],
                        startPoint: .top, endPoint: .bottom
                    )
                )

                HStack(spacing: 8) {
                    chip(label: launch.family.shortLabel, color: Palette.familyColor(launch.family))
                    Spacer()
                    if let patchURL = launch.mission?.image?.imageUrl {
                        AsyncImage(url: patchURL) { phase in
                            Group {
                                if case .success(let img) = phase {
                                    img.resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                } else {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Palette.panelSolid)
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Image(systemName: "photo.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(Palette.muted)
                                        )
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Palette.stroke, lineWidth: 0.5))
                        }
                    }
                    statusChip
                }
                .padding(10)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(launch.name)
                    .font(Font2.orbitron(15, weight: .semibold))
                    .foregroundColor(Palette.text)
                    .lineLimit(2)

                Text(launch.rocket?.configuration?.name ?? launch.family.label)
                    .font(Font2.mono(11, weight: .medium))
                    .foregroundColor(Palette.accent)

                if let pad = launch.pad?.name {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill").font(.system(size: 9))
                        Text(pad).lineLimit(1)
                    }
                    .font(Font2.mono(10))
                    .foregroundColor(Palette.faint)
                }

                Spacer(minLength: 4)

                Divider().background(Palette.stroke)

                HStack(alignment: .center) {
                    boosterTag
                    Spacer()
                    InlineCountdown(date: launch.net)
                        .environmentObject(lang)
                }
            }
            .padding(14)
        }
        .panel(radius: 18)
        .contentShape(Rectangle())
    }

    private var familyBackdrop: some View {
        RadialGradient(
            colors: [Palette.familyColor(launch.family).opacity(0.4), .clear],
            center: .center,
            startRadius: 5,
            endRadius: 160
        )
        .background(Palette.bg2)
    }

    private var boosterTag: some View {
        Group {
            if let stage = launch.rocket?.launcherStage?.first {
                if let serial = stage.launcher?.serialNumber {
                    HStack(spacing: 6) {
                        Text(serial)
                            .font(Font2.mono(10, weight: .semibold))
                            .foregroundColor(Color(red: 0.812, green: 0.878, blue: 0.984))
                            .padding(.horizontal, 7).padding(.vertical, 2)
                            .background(Palette.accent.opacity(0.10))
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Palette.stroke, lineWidth: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        if let n = stage.launcherFlightNumber {
                            Text("#\(n)")
                                .font(Font2.mono(10))
                                .foregroundColor(Palette.ss)
                        }
                        Text(stage.reused == true ? lang.t("reused") : lang.t("firstflight"))
                            .font(Font2.mono(9))
                            .tracking(0.8)
                            .foregroundColor(stage.reused == true ? Palette.go : Palette.accent)
                    }
                }
            } else {
                Text(lang.t("newvehicle"))
                    .font(Font2.mono(9))
                    .tracking(0.6)
                    .foregroundColor(Palette.faint)
            }
        }
    }

    private func chip(label: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(label)
                .font(Font2.mono(10, weight: .semibold))
                .foregroundColor(Palette.text)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(.black.opacity(0.55))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var statusChip: some View {
        Text(launch.status?.abbrev ?? "—")
            .font(Font2.mono(9, weight: .semibold))
            .tracking(1)
            .foregroundColor(Palette.statusColor(launch.status?.kind ?? .unknown))
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(.black.opacity(0.55))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Palette.statusColor(launch.status?.kind ?? .unknown), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
