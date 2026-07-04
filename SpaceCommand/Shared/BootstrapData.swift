import Foundation

enum BootstrapData {
    private static let iso = ISO8601DateFormatter()
    private static func d(_ s: String) -> Date? { iso.date(from: s) }

    static let launches: [Launch] = [
        Launch(
            id: "starlink-12-18",
            name: "Falcon 9 Block 5 | Starlink Group 12-18",
            status: LaunchStatus(id: 1, name: "Go for Launch", abbrev: "Go"),
            net: d("2026-06-25T14:30:00Z"),
            windowStart: d("2026-06-25T14:30:00Z"),
            windowEnd: d("2026-06-25T15:30:00Z"),
            lsp: LaunchProvider(name: "SpaceX", totalLaunchCount: 523, successfulLandings: 481, consecutiveSuccessfulLandings: 52, consecutiveSuccessfulLaunches: 112),
            rocket: RocketWrapper(
                configuration: RocketConfiguration(id: 188, name: "Falcon 9", fullName: "Falcon 9 Block 5", variant: "Block 5", length: 70, diameter: 3.7, launchMass: 549, toThrust: 7607, leoCapacity: 22800, gtoCapacity: 8300, toThrustImg: nil, imageUrl: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_9_image_20230807133459.jpeg", infoUrl: nil, wikiUrl: nil),
                launcherStage: [LauncherStage(id: 1234, type: "first", reused: true, launcherFlightNumber: 28, launcher: Launcher(id: 1, serialNumber: "B1083", status: "Active", flights: 20, lastLaunchDate: nil, firstLaunchDate: nil, attemptedLandings: 20, successfulLandings: 19, flightProven: true, imageUrl: nil), landing: nil, previousFlightDate: nil, turnAroundTimeDays: nil)]
            ),
            mission: Mission(id: 1, name: "Starlink Group 12-18", description: nil, type: "Communications", orbit: Orbit(name: "Low Earth Orbit", abbrev: "LEO"), image: nil),
            pad: Pad(id: 25, name: "Launch Complex 39A", mapImage: nil, location: PadLocation(name: "Kennedy Space Center", countryCode: "US")),
            image: ImageRef(imageUrl: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_9_image_20230807133459.jpeg"), thumbnailUrl: nil),
            webcastLive: false,
            vidUrls: [VideoLink(url: URL(string: "https://www.youtube.com/watch?v=example"), title: "Live", source: "YouTube")]
        ),
        Launch(
            id: "ussf-106",
            name: "Falcon Heavy | USSF-106",
            status: LaunchStatus(id: 1, name: "Go for Launch", abbrev: "Go"),
            net: d("2026-07-10T18:00:00Z"),
            windowStart: d("2026-07-10T18:00:00Z"),
            windowEnd: d("2026-07-10T20:00:00Z"),
            lsp: LaunchProvider(name: "SpaceX", totalLaunchCount: 523, successfulLandings: 481, consecutiveSuccessfulLandings: 52, consecutiveSuccessfulLaunches: 112),
            rocket: RocketWrapper(
                configuration: RocketConfiguration(id: 189, name: "Falcon Heavy", fullName: "Falcon Heavy", variant: "Block 5", length: 70, diameter: 12.2, launchMass: 1420, toThrust: 22819, leoCapacity: 63800, gtoCapacity: 26700, toThrustImg: nil, imageUrl: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_heavy_image_20220129192819.jpeg", infoUrl: nil, wikiUrl: nil),
                launcherStage: [LauncherStage(id: 2345, type: "first", reused: true, launcherFlightNumber: 12, launcher: Launcher(id: 2, serialNumber: "B1064", status: "Active", flights: 8, lastLaunchDate: nil, firstLaunchDate: nil, attemptedLandings: 8, successfulLandings: 7, flightProven: true, imageUrl: nil), landing: nil, previousFlightDate: nil, turnAroundTimeDays: nil)]
            ),
            mission: Mission(id: 2, name: "USSF-106", description: nil, type: "Government/Military", orbit: Orbit(name: "Geostationary Transfer Orbit", abbrev: "GTO"), image: nil),
            pad: Pad(id: 39, name: "Launch Complex 39A", mapImage: nil, location: PadLocation(name: "Kennedy Space Center", countryCode: "US")),
            image: ImageRef(imageUrl: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_heavy_image_20220129192819.jpeg"), thumbnailUrl: nil),
            webcastLive: false,
            vidUrls: nil
        ),
        Launch(
            id: "starship-ift-12",
            name: "Starship | IFT-12",
            status: LaunchStatus(id: 1, name: "Go for Launch", abbrev: "Go"),
            net: d("2026-08-01T12:00:00Z"),
            windowStart: d("2026-08-01T12:00:00Z"),
            windowEnd: d("2026-08-01T14:00:00Z"),
            lsp: LaunchProvider(name: "SpaceX", totalLaunchCount: 523, successfulLandings: 481, consecutiveSuccessfulLandings: 52, consecutiveSuccessfulLaunches: 112),
            rocket: RocketWrapper(
                configuration: RocketConfiguration(id: 190, name: "Starship", fullName: "Starship", variant: "Super Heavy + Starship", length: 121, diameter: 9, launchMass: 5000, toThrust: 34400, leoCapacity: 100000, gtoCapacity: 50000, toThrustImg: nil, imageUrl: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/starship_on_the_image_20250111100520.jpg", infoUrl: nil, wikiUrl: nil),
                launcherStage: [LauncherStage(id: 3456, type: "first", reused: true, launcherFlightNumber: 3, launcher: Launcher(id: 3, serialNumber: "B16", status: "Active", flights: 3, lastLaunchDate: nil, firstLaunchDate: nil, attemptedLandings: 3, successfulLandings: 1, flightProven: true, imageUrl: nil), landing: nil, previousFlightDate: nil, turnAroundTimeDays: nil)]
            ),
            mission: Mission(id: 3, name: "Starship IFT-12", description: nil, type: "Test Flight", orbit: Orbit(name: "Suborbital", abbrev: "Suborbital"), image: nil),
            pad: Pad(id: 198, name: "Starship Orbital Launch Site", mapImage: nil, location: PadLocation(name: "Starbase", countryCode: "US")),
            image: ImageRef(imageUrl: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/starship_on_the_image_20250111100520.jpg"), thumbnailUrl: nil),
            webcastLive: false,
            vidUrls: nil
        )
    ]
}
