import SwiftUI

struct WatchHomeView: View {
    @EnvironmentObject var model: WatchLaunchesModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let next = model.next {
                    NavigationLink(value: next) {
                        WatchNextLaunchCard(launch: next)
                    }
                    .buttonStyle(.plain)
                }

                if model.launches.count > 1 {
                    Text("À VENIR")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .tracking(1.5)
                        .foregroundColor(Palette.faint)
                        .padding(.top, 4)

                    ForEach(model.launches.dropFirst().prefix(10)) { launch in
                        NavigationLink(value: launch) {
                            WatchLaunchRow(launch: launch)
                        }
                        .buttonStyle(.plain)
                    }
                }

                footer
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Space Command")
        .navigationDestination(for: Launch.self) { launch in
            WatchLaunchDetailView(launch: launch)
        }
        .refreshable { await model.refresh(force: true) }
        .background(Color.black)
    }

    @ViewBuilder
    private var footer: some View {
        HStack(spacing: 6) {
            if model.isStale {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 9))
                    .foregroundColor(Palette.tbd)
            }
            if let date = model.lastUpdated {
                Text("MAJ \(date.formatted(date: .omitted, time: .shortened))")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Palette.faint)
            }
            Spacer()
            Button {
                Task { await model.refresh(force: true) }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Palette.accent)
            }
            .buttonStyle(.plain)
            .disabled(model.isLoading)
        }
        .padding(.top, 6)
    }
}

/// Hero card for the next liftoff with a live countdown.
struct WatchNextLaunchCard: View {
    let launch: Launch

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Circle()
                    .fill(Palette.familyColor(launch.family))
                    .frame(width: 6, height: 6)
                Text("PROCHAIN DÉCOLLAGE")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(1.2)
                    .foregroundColor(Palette.accent)
            }

            Text(launch.mission?.name ?? launch.name)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(Palette.text)
                .lineLimit(2)

            WatchCountdown(date: launch.net, compact: false)

            if let pad = launch.pad?.location?.name {
                Text(pad)
                    .font(.system(size: 11))
                    .foregroundColor(Palette.muted)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Palette.panel.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Palette.stroke, lineWidth: 0.5)
        )
    }
}

struct WatchLaunchRow: View {
    let launch: Launch

    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Palette.familyColor(launch.family))
                .frame(width: 3, height: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(launch.mission?.name ?? launch.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Palette.text)
                    .lineLimit(1)
                WatchCountdown(date: launch.net, compact: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Palette.panel.opacity(0.45))
        )
    }
}

/// Live countdown, ticking every second via TimelineView.
struct WatchCountdown: View {
    let date: Date?
    var compact: Bool

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            label(now: context.date)
        }
    }

    @ViewBuilder
    private func label(now: Date) -> some View {
        let state = CountdownState.from(date)
        if state.isTBD {
            text("À confirmer", color: Palette.tbd)
        } else if state.isLive {
            HStack(spacing: 4) {
                Circle().fill(Palette.hold).frame(width: 5, height: 5)
                text("EN COURS", color: Palette.hold)
            }
        } else if state.isLaunched {
            text("Lancé", color: Palette.muted)
        } else if state.days > 0 {
            text("T- \(state.days)j \(state.hours)h \(state.minutes)m", color: compact ? Palette.muted : Palette.text)
        } else {
            text(String(format: "T- %02d:%02d:%02d", state.hours, state.minutes, state.seconds), color: state.hours < 1 ? Palette.hold : Palette.text)
        }
    }

    private func text(_ s: String, color: Color) -> some View {
        Text(s)
            .font(.system(size: compact ? 11 : 18, weight: .semibold, design: .monospaced))
            .foregroundColor(color)
    }
}
