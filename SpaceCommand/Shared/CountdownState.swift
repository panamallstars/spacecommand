import Foundation

struct CountdownState {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    let isLive: Bool
    let isLaunched: Bool
    let isTBD: Bool

    static func from(_ date: Date?) -> CountdownState {
        guard let date else {
            return .init(days: 0, hours: 0, minutes: 0, seconds: 0, isLive: false, isLaunched: false, isTBD: true)
        }
        let diff = date.timeIntervalSinceNow
        if diff <= 0 && diff > -10800 {
            return .init(days: 0, hours: 0, minutes: 0, seconds: 0, isLive: true, isLaunched: false, isTBD: false)
        }
        if diff <= 0 {
            return .init(days: 0, hours: 0, minutes: 0, seconds: 0, isLive: false, isLaunched: true, isTBD: false)
        }
        let total = Int(diff)
        return .init(
            days: total / 86400,
            hours: (total % 86400) / 3600,
            minutes: (total % 3600) / 60,
            seconds: total % 60,
            isLive: false,
            isLaunched: false,
            isTBD: false
        )
    }
}
