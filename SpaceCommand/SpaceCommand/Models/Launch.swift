import Foundation

struct LaunchResponse: Decodable {
    let results: [Launch]
}

struct Launch: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let status: LaunchStatus?
    let net: Date?
    let windowStart: Date?
    let windowEnd: Date?
    let lsp: LaunchProvider?
    let rocket: RocketWrapper?
    let mission: Mission?
    let pad: Pad?
    let image: ImageRef?
    let webcastLive: Bool?
    let vidUrls: [VideoLink]?

    var family: RocketFamily {
        let n = rocket?.configuration?.name?.lowercased() ?? ""
        if n.contains("heavy") { return .falconHeavy }
        if n.contains("starship") || n.contains("super heavy") { return .starship }
        if n.contains("falcon 9") { return .falcon9 }
        return .other
    }

    var orbit: String? {
        mission?.orbit?.name
    }

    var heroImageURL: URL? {
        image?.imageUrl ?? pad?.mapImage
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case net
        case windowStart = "window_start"
        case windowEnd = "window_end"
        case lsp = "launch_service_provider"
        case rocket
        case mission
        case pad
        case image
        case webcastLive = "webcast_live"
        case vidUrls = "vid_urls"
    }
}

struct LaunchStatus: Decodable, Hashable {
    let id: Int?
    let name: String?
    let abbrev: String?

    enum Kind { case go, hold, tbd, unknown }

    var kind: Kind {
        let s = (abbrev ?? name ?? "").lowercased()
        if s.contains("go") { return .go }
        if s.contains("hold") || s.contains("fail") { return .hold }
        if s.contains("tbc") || s.contains("tbd") { return .tbd }
        return .unknown
    }
}

struct LaunchProvider: Decodable, Hashable {
    let name: String?
    let totalLaunchCount: Int?
    let successfulLandings: Int?
    let consecutiveSuccessfulLandings: Int?
    let consecutiveSuccessfulLaunches: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case totalLaunchCount = "total_launch_count"
        case successfulLandings = "successful_landings"
        case consecutiveSuccessfulLandings = "consecutive_successful_landings"
        case consecutiveSuccessfulLaunches = "consecutive_successful_launches"
    }
}

struct RocketWrapper: Decodable, Hashable {
    let configuration: RocketConfiguration?
    let launcherStage: [LauncherStage]?

    enum CodingKeys: String, CodingKey {
        case configuration
        case launcherStage = "launcher_stage"
    }
}

struct RocketConfiguration: Decodable, Hashable {
    let id: Int?
    let name: String?
    let fullName: String?
    let variant: String?
    let length: Double?
    let diameter: Double?
    let launchMass: Int?
    let toThrust: Int?
    let leoCapacity: Int?
    let gtoCapacity: Int?
    let toThrustImg: String?
    let imageUrl: String?
    let infoUrl: String?
    let wikiUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name, variant, length, diameter
        case fullName = "full_name"
        case launchMass = "launch_mass"
        case toThrust = "to_thrust"
        case leoCapacity = "leo_capacity"
        case gtoCapacity = "gto_capacity"
        case toThrustImg = "to_thrust_img"
        case imageUrl = "image_url"
        case infoUrl = "info_url"
        case wikiUrl = "wiki_url"
    }
}

struct LauncherStage: Decodable, Hashable {
    let id: Int?
    let type: String?
    let reused: Bool?
    let launcherFlightNumber: Int?
    let launcher: Launcher?
    let landing: Landing?
    let previousFlightDate: Date?
    let turnAroundTimeDays: Int?

    enum CodingKeys: String, CodingKey {
        case id, type, reused, launcher, landing
        case launcherFlightNumber = "launcher_flight_number"
        case previousFlightDate = "previous_flight_date"
        case turnAroundTimeDays = "turn_around_time_days"
    }
}

struct Launcher: Decodable, Hashable {
    let id: Int?
    let serialNumber: String?
    let status: String?
    let flights: Int?
    let lastLaunchDate: Date?
    let firstLaunchDate: Date?
    let attemptedLandings: Int?
    let successfulLandings: Int?
    let flightProven: Bool?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, status, flights
        case serialNumber = "serial_number"
        case lastLaunchDate = "last_launch_date"
        case firstLaunchDate = "first_launch_date"
        case attemptedLandings = "attempted_landings"
        case successfulLandings = "successful_landings"
        case flightProven = "flight_proven"
        case imageUrl = "image_url"
    }
}

struct Landing: Decodable, Hashable {
    let attempt: Bool?
    let success: Bool?
    let location: LandingLocation?
    let type: LandingType?
}

struct LandingLocation: Decodable, Hashable {
    let name: String?
    let abbrev: String?
    let description: String?
}

struct LandingType: Decodable, Hashable {
    let name: String?
    let abbrev: String?
}

struct Mission: Decodable, Hashable {
    let id: Int?
    let name: String?
    let description: String?
    let type: String?
    let orbit: Orbit?
    let image: ImageRef?

    enum CodingKeys: String, CodingKey {
        case id, name, description, type, orbit, image
    }
}

struct Orbit: Decodable, Hashable {
    let name: String?
    let abbrev: String?
}

struct Pad: Decodable, Hashable {
    let id: Int?
    let name: String?
    let mapImage: URL?
    let location: PadLocation?

    enum CodingKeys: String, CodingKey {
        case id, name, location
        case mapImage = "map_image"
    }
}

struct PadLocation: Decodable, Hashable {
    let name: String?
    let countryCode: String?

    enum CodingKeys: String, CodingKey {
        case name
        case countryCode = "country_code"
    }
}

struct ImageRef: Decodable, Hashable {
    let imageUrl: URL?
    let thumbnailUrl: URL?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case thumbnailUrl = "thumbnail_url"
    }
}

struct VideoLink: Decodable, Hashable {
    let url: URL?
    let title: String?
    let source: String?
}

enum RocketFamily: String, CaseIterable, Identifiable {
    case falcon9, falconHeavy, starship, other
    var id: String { rawValue }

    var label: String {
        switch self {
        case .falcon9: return "Falcon 9"
        case .falconHeavy: return "Falcon Heavy"
        case .starship: return "Starship"
        case .other: return "Other"
        }
    }

    var shortLabel: String {
        switch self {
        case .falcon9: return "F9"
        case .falconHeavy: return "FH"
        case .starship: return "SS"
        case .other: return "·"
        }
    }
}
