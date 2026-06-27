import Foundation

struct BoosterStats {
    let fleetLeader: String?
    let fleetLeaderFlights: Int
    let turnaroundDays: Int
    let turnaroundBooster: String?
}

class StatsCalculator {
    static func calculateBoosterStats(launches: [Launch]) -> BoosterStats {
        var boosterStats: [String: (flights: Int, launchDates: [Date])] = [:]

        for launch in launches {
            guard let stages = launch.rocket?.launcherStages else { continue }
            for stage in stages {
                guard let serial = stage.launcher?.serialNumber else { continue }
                if boosterStats[serial] == nil {
                    boosterStats[serial] = (flights: 0, launchDates: [])
                }
                boosterStats[serial]?.flights += 1
                if let net = launch.net {
                    boosterStats[serial]?.launchDates.append(net)
                }
            }
        }

        // Find fleet leader (most flights)
        var maxFlights = 0
        var fleetLeader: String? = nil
        for (booster, stats) in boosterStats {
            if stats.flights > maxFlights {
                maxFlights = stats.flights
                fleetLeader = booster
            }
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

        return BoosterStats(
            fleetLeader: fleetLeader,
            fleetLeaderFlights: maxFlights,
            turnaroundDays: minTurnaround == Int.max ? 0 : minTurnaround,
            turnaroundBooster: turnaroundBooster
        )
    }
}
