import Foundation

struct RocketReference: Identifiable, Hashable {
    let id: String
    let name: String
    let variant: String
    let inService: Bool
    let firstFlight: String
    let height: String
    let diameter: String
    let mass: String
    let payloadLEO: String
    let stages: String
    let engines: String
    let reusable: String
    let imageURL: URL?
    let wikipediaTitle: String
    let palmares: [Achievement]

    struct Achievement: Hashable {
        let label: String
        let kind: Kind
        enum Kind { case neutral, ok, ko }
    }
}

struct BoosterReference: Identifiable, Hashable {
    let id: String
    let serial: String
    let flights: Int
    let landings: Int
    let status: String
    let notable: String
    let lastPad: String
}

struct CrewDragonReference: Identifiable, Hashable {
    let id: String
    let name: String
    let serial: String
    let variant: String
    let missions: Int
    let crewCapacity: String
    let status: String
    let imageURL: URL?
    let wikipediaTitle: String
    let palmares: [RocketReference.Achievement]
    let firstFlight: String?
    let lastFlight: String?
    let nextFlight: String?
}

enum RocketCatalog {
    static let inService: [RocketReference] = [
        RocketReference(
            id: "falcon9",
            name: "Falcon 9",
            variant: "Block 5 · Two-stage · Reusable booster",
            inService: true,
            firstFlight: "2010",
            height: "70 m",
            diameter: "3.7 m",
            mass: "549 t",
            payloadLEO: "22.8 t",
            stages: "2",
            engines: "9 × Merlin 1D",
            reusable: "Yes (1st stage)",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_9_image_20230807133459.jpeg"),
            wikipediaTitle: "Falcon 9",
            palmares: [
                .init(label: "Most flown active orbital rocket", kind: .ok),
                .init(label: "Reuse: same booster up to 28×", kind: .ok),
                .init(label: "Land + relaunch in 21 days", kind: .ok)
            ]
        ),
        RocketReference(
            id: "falconheavy",
            name: "Falcon Heavy",
            variant: "Two side boosters + center core",
            inService: true,
            firstFlight: "2018",
            height: "70 m",
            diameter: "12.2 m (with boosters)",
            mass: "1 420 t",
            payloadLEO: "63.8 t",
            stages: "2",
            engines: "27 × Merlin 1D",
            reusable: "Yes (boosters)",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_heavy_image_20220129192819.jpeg"),
            wikipediaTitle: "Falcon Heavy",
            palmares: [
                .init(label: "Most powerful operational rocket", kind: .ok),
                .init(label: "Synchronized booster recovery", kind: .ok)
            ]
        ),
        RocketReference(
            id: "starship",
            name: "Starship",
            variant: "Super Heavy + Starship · fully reusable",
            inService: true,
            firstFlight: "2023 (orbital)",
            height: "121 m",
            diameter: "9 m",
            mass: "5 000 t",
            payloadLEO: "100–150 t",
            stages: "2",
            engines: "33 × Raptor (booster) · 6 × Raptor (ship)",
            reusable: "Yes (full stack)",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/starship_on_the_image_20250111100520.jpg"),
            wikipediaTitle: "SpaceX Starship",
            palmares: [
                .init(label: "Tallest rocket ever built", kind: .ok),
                .init(label: "Mechazilla catch (booster)", kind: .ok),
                .init(label: "Development program", kind: .neutral)
            ]
        )
    ]

    static let retired: [RocketReference] = [
        RocketReference(
            id: "falcon1",
            name: "Falcon 1",
            variant: "First privately developed orbital rocket",
            inService: false,
            firstFlight: "2006",
            height: "21 m",
            diameter: "1.7 m",
            mass: "38 t",
            payloadLEO: "670 kg",
            stages: "2",
            engines: "1 × Merlin 1A/C",
            reusable: "No",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_image_20190222030438.jpeg"),
            wikipediaTitle: "Falcon 1",
            palmares: [
                .init(label: "5 flights · 2 successes", kind: .neutral),
                .init(label: "First private orbital launch", kind: .ok)
            ]
        ),
        RocketReference(
            id: "falcon9v1",
            name: "Falcon 9 v1.0 / v1.1",
            variant: "Early Falcon 9 variants",
            inService: false,
            firstFlight: "2010",
            height: "47–68 m",
            diameter: "3.7 m",
            mass: "333–506 t",
            payloadLEO: "8.5–13.2 t",
            stages: "2",
            engines: "9 × Merlin 1C/1D",
            reusable: "Experimental",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_image_20190222030438.jpeg"),
            wikipediaTitle: "Falcon 9 v1.0",
            palmares: [
                .init(label: "First propulsive landing attempt", kind: .ok),
                .init(label: "CRS-7 in-flight failure (2015)", kind: .ko)
            ]
        )
    ]

    static let activeBoosters: [BoosterReference] = [
        BoosterReference(id: "b1067", serial: "B1067", flights: 35, landings: 34, status: "Active", notable: "Reuse record holder", lastPad: "LC-39A"),
        BoosterReference(id: "b1061", serial: "B1061", flights: 25, landings: 24, status: "Active", notable: "Crew Dragon veteran", lastPad: "LC-39A"),
        BoosterReference(id: "b1062", serial: "B1062", flights: 24, landings: 23, status: "Active", notable: "GPS & national security missions", lastPad: "SLC-4E"),
        BoosterReference(id: "b1069", serial: "B1069", flights: 22, landings: 21, status: "Active", notable: "High-cadence Starlink launcher", lastPad: "LC-40"),
        BoosterReference(id: "b1076", serial: "B1076", flights: 20, landings: 19, status: "Active", notable: "Rapid turnaround demonstrator", lastPad: "LC-39A"),
        BoosterReference(id: "b1078", serial: "B1078", flights: 18, landings: 17, status: "Active", notable: "Starlink workhorse", lastPad: "LC-40"),
        BoosterReference(id: "b1081", serial: "B1081", flights: 16, landings: 15, status: "Active", notable: "Multi-manifest capable", lastPad: "LC-39A"),
        BoosterReference(id: "b1083", serial: "B1083", flights: 20, landings: 19, status: "Active", notable: "Latest high-flier", lastPad: "LC-40"),
    ]

    static let crewDragons: [CrewDragonReference] = [
        CrewDragonReference(
            id: "endeavour",
            name: "Endeavour",
            serial: "C206",
            variant: "Crew Dragon 2",
            missions: 5,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "First Crew Dragon in orbit (Demo-2)", kind: .ok),
                .init(label: "5 crewed missions flown", kind: .ok)
            ],
            firstFlight: "2020-05-30",
            lastFlight: "2023-10-16",
            nextFlight: "2026-10-15"
        ),
        CrewDragonReference(
            id: "resilience",
            name: "Resilience",
            serial: "C207",
            variant: "Crew Dragon 2",
            missions: 4,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "Inspiration4 (first all-civilian orbital crew)", kind: .ok),
                .init(label: "4 missions flown", kind: .ok)
            ],
            firstFlight: "2020-11-15",
            lastFlight: "2023-02-26",
            nextFlight: "2026-09-20"
        ),
        CrewDragonReference(
            id: "endurance",
            name: "Endurance",
            serial: "C210",
            variant: "Crew Dragon 2",
            missions: 4,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "Crew-3, Crew-5, Crew-7, Crew-9", kind: .neutral),
                .init(label: "4 ISS rotation missions", kind: .ok)
            ],
            firstFlight: "2022-03-02",
            lastFlight: "2024-08-15",
            nextFlight: "2026-08-10"
        ),
        CrewDragonReference(
            id: "freedom",
            name: "Freedom",
            serial: "C212",
            variant: "Crew Dragon 2",
            missions: 3,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "Crew-4, Axiom-1, Crew-8", kind: .neutral),
                .init(label: "Commercial & NASA missions", kind: .ok)
            ],
            firstFlight: "2023-04-27",
            lastFlight: "2024-03-09",
            nextFlight: "2026-07-25"
        ),
    ]
}
