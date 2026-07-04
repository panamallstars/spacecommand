import SwiftUI

// CountdownState lives in Shared/CountdownState.swift (used by the watch app too)

struct CountdownView: View {
    let date: Date?
    @EnvironmentObject var lang: LanguageStore
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let state = CountdownState.from(date)
        Group {
            if state.isTBD {
                Text(lang.t("cd_tbd"))
                    .font(Font2.mono(14, weight: .semibold))
                    .foregroundColor(Palette.tbd)
            } else if state.isLaunched {
                Text(lang.t("cd_launched"))
                    .font(Font2.mono(14, weight: .semibold))
                    .foregroundColor(Palette.muted)
            } else if state.isLive {
                HStack(spacing: 8) {
                    Circle().fill(Palette.hold).frame(width: 8, height: 8)
                    Text(lang.t("cd_inprogress"))
                        .font(Font2.mono(11, weight: .semibold))
                        .foregroundColor(Palette.hold)
                }
            } else {
                HStack(spacing: 6) {
                    cell(value: state.days, label: lang.t("cd_days"))
                    cell(value: state.hours, label: lang.t("cd_hours"))
                    cell(value: state.minutes, label: lang.t("cd_min"))
                    cell(value: state.seconds, label: lang.t("cd_sec"))
                }
            }
        }
        .onReceive(timer) { now = $0 }
    }

    private func cell(value: Int, label: String) -> some View {
        VStack(spacing: 6) {
            Text(String(format: "%02d", value))
                .font(Font2.mono(22, weight: .semibold))
                .foregroundColor(Palette.text)
                .contentTransition(.numericText(value: Double(value)))
            Text(label)
                .font(Font2.mono(8, weight: .medium))
                .tracking(1.4)
                .foregroundColor(Palette.faint)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Palette.stroke, lineWidth: 0.5)
        )
    }
}

struct InlineCountdown: View {
    let date: Date?
    @EnvironmentObject var lang: LanguageStore
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let state = CountdownState.from(date)
        Group {
            if state.isTBD {
                Text(lang.t("cd_tbd"))
                    .foregroundColor(Palette.tbd)
            } else if state.isLaunched {
                Text(lang.t("cd_launched"))
                    .foregroundColor(Palette.muted)
            } else if state.isLive {
                Text(lang.t("cd_inprogress"))
                    .foregroundColor(Palette.hold)
            } else if state.days > 0 {
                Text("T- \(state.days)\(lang.t("dayunit")) \(state.hours)h \(state.minutes)m")
                    .foregroundColor(Palette.text)
            } else {
                Text(String(format: "T- %02d:%02d:%02d", state.hours, state.minutes, state.seconds))
                    .foregroundColor(state.hours < 1 ? Palette.hold : Palette.text)
            }
        }
        .font(Font2.mono(14, weight: .semibold))
        .onReceive(timer) { now = $0 }
    }
}
