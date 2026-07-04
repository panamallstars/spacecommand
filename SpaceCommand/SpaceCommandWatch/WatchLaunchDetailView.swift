import SwiftUI

struct WatchLaunchDetailView: View {
    let launch: Launch

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(Palette.familyColor(launch.family))
                        .frame(width: 6, height: 6)
                    Text(launch.rocket?.configuration?.fullName ?? launch.family.label)
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(Palette.familyColor(launch.family))
                        .lineLimit(1)
                }

                Text(launch.mission?.name ?? launch.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Palette.text)

                WatchCountdown(date: launch.net, compact: false)

                VStack(alignment: .leading, spacing: 6) {
                    if let net = launch.net {
                        fact(icon: "calendar", value: net.formatted(date: .abbreviated, time: .shortened))
                    }
                    if let pad = launch.pad?.name {
                        fact(icon: "location.fill", value: pad)
                    }
                    if let site = launch.pad?.location?.name {
                        fact(icon: "globe.americas.fill", value: site)
                    }
                    if let orbit = launch.orbit {
                        fact(icon: "circle.dashed", value: orbit)
                    }
                    if let status = launch.status?.name {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Palette.statusColor(launch.status?.kind ?? .unknown))
                                .frame(width: 6, height: 6)
                            Text(status)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Palette.statusColor(launch.status?.kind ?? .unknown))
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Palette.panel.opacity(0.6))
                )

                if let stage = launch.rocket?.launcherStage?.first,
                   let serial = stage.launcher?.serialNumber {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 10))
                            .foregroundColor(Palette.accent)
                        Text(stage.launcherFlightNumber.map { "\(serial) · vol #\($0)" } ?? serial)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(Palette.muted)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Mission")
        .background(Color.black)
    }

    private func fact(icon: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(Palette.accent)
                .frame(width: 14)
            Text(value)
                .font(.system(size: 12))
                .foregroundColor(Palette.text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
