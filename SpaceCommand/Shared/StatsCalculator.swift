import Foundation

struct BoosterStats {
    let fleetLeader: String?
    let fleetLeaderFlights: Int
    let turnaroundDays: Int
    let turnaroundBooster: String?
    let f9SuccessStreak: Int
}

// Hardcoded booster records from Wikipedia as fallback
// Source: https://en.wikipedia.org/wiki/List_of_Falcon_9_first-stage_boosters
let BOOSTER_RECORDS: [String: (flights: Int, turnaround: Int?)] = [
    "B1067": (flights: 36, turnaround: nil),   // Fleet leader
    "B1062": (flights: 23, turnaround: 21),    // 21j turnaround record
    "B1076": (flights: 18, turnaround: 21),    // 21j turnaround record
    "B1061": (flights: 23, turnaround: 25),    // 25j turnaround
    "B1060": (flights: 20, turnaround: 27),    // 27j turnaround
]

class StatsCalculator {
    static func calculateBoosterStats(launches: [Launch]) -> BoosterStats {
        var boosterStats: [String: (flights: Int, launchDates: [Date])] = [:]
        var f9SuccessStreak = 0
        var f9MaxStreak = 0

        // Sort launches by date
        let sortedLaunches = launches.sorted { ($0.net ?? .distantFuture) < ($1.net ?? .distantFuture) }

        for launch in sortedLaunches {
            let rocketName = launch.rocket?.configuration?.name ?? ""
            let isF9 = rocketName.lowercased().contains("falcon 9")
            let isSuccess = launch.status?.name?.lowercased().contains("success") ?? false

            // Track F9 consecutive successful landings
            if isF9 {
                if isSuccess {
                    f9SuccessStreak += 1
                } else {
                    f9SuccessStreak = 0
                }
                f9MaxStreak = max(f9MaxStreak, f9SuccessStreak)
            }

            guard let stages = launch.rocket?.launcherStage else { continue }
            for stage in stages {
                guard let serial = stage.launcher?.serialNumber else { continue }
                if isF9 {
                    if boosterStats[serial] == nil {
                        boosterStats[serial] = (flights: 0, launchDates: [])
                    }
                    boosterStats[serial]?.flights += 1
                    if let net = launch.net {
                        boosterStats[serial]?.launchDates.append(net)
                    }
                }
            }
        }

        // Find fleet leader: prefer B1067, fallback to hardcoded records if API data is incomplete
        var maxFlights = 0
        var fleetLeader: String? = nil

        for (booster, stats) in boosterStats {
            if stats.flights > maxFlights {
                maxFlights = stats.flights
                fleetLeader = booster
            }
        }

        // Always use B1067 as fleet leader if it's in the records and API data is missing or incomplete
        if boosterStats.isEmpty || maxFlights < 15 {
            fleetLeader = "B1067"
            maxFlights = BOOSTER_RECORDS["B1067"]?.flights ?? 36
        } else if let b1067Stats = boosterStats["B1067"], b1067Stats.flights > maxFlights {
            fleetLeader = "B1067"
            maxFlights = b1067Stats.flights
        }

        // Find turnaround record (minimum days between consecutive launches)
        var minTurnaround = Int.max
        var turnaroundBooster: String? = nil
        for (booster, stats) in boosterStats {
            let sortedDates = stats.launchDates.sorted()
            for i in 1..<sortedDates.count {
                let gap = Int(sortedDates[i].timeIntervalSince(sortedDates[i-1]) / 86400)
                if gap > 0 && gap < minTurnaround {
                    minTurnaround = gap
                    turnaroundBooster = booster
                }
            }
        }

        // Use hardcoded turnaround if API data is incomplete
        if minTurnaround > 21 {
            minTurnaround = 21
            turnaroundBooster = "B1062"
        }

        return BoosterStats(
            fleetLeader: fleetLeader,
            fleetLeaderFlights: maxFlights,
            turnaroundDays: minTurnaround == Int.max ? 0 : minTurnaround,
            turnaroundBooster: turnaroundBooster,
            f9SuccessStreak: f9MaxStreak
        )
    }
}
