import Foundation

struct RocketReference: Identifiable, Hashable {
    let id: String
    let name: String
    let variant: String
    let inService: Bool
    let firstFlight: String
    let lastFlight: String?
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

struct DragonFlight: Hashable {
    let mission: String
    let launchDate: String
    let landingDate: String?
    let crew: [String]
}

struct CargoDragonReference: Identifiable, Hashable {
    let id: String
    let serial: String
    let status: String
    let firstFlight: String
    let missions: Int
    let flightHistory: [DragonFlight]
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
    let flightHistory: [DragonFlight]
}

enum RocketCatalog {
    static let inService: [RocketReference] = [
        RocketReference(
            id: "falcon9",
            name: "Falcon 9",
            variant: "Block 5 · Two-stage · Reusable booster",
            inService: true,
            firstFlight: "2010",
            lastFlight: nil,
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
            lastFlight: nil,
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
            firstFlight: "Apr 2023 (IFT-1)",
            lastFlight: "24 Jul 2026 (IFT-13)",
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
                .init(label: "IFT-13: first op. Starlink V3 deploy", kind: .ok),
                .init(label: "13 flight tests since 2023", kind: .neutral)
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
            lastFlight: "2009",
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
            lastFlight: "2016",
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
        BoosterReference(id: "b1067", serial: "B1067", flights: 36, landings: 36, status: "Active", notable: "Reuse record holder · perfect landing streak", lastPad: "SLC-40"),
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
            missions: 6,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "First Crew Dragon in orbit (Demo-2)", kind: .ok),
                .init(label: "6 crewed missions flown", kind: .ok)
            ],
            firstFlight: "2020-05-30",
            lastFlight: "2025-08-01",
            nextFlight: nil,
            flightHistory: [
                .init(mission: "Demo-2", launchDate: "2020-05-30", landingDate: "2020-08-02", crew: ["Douglas Hurley", "Robert Behnken"]),
                .init(mission: "Crew-2", launchDate: "2021-04-23", landingDate: "2021-11-09", crew: ["Shane Kimbrough", "Megan McArthur", "Akihiko Hoshide", "Thomas Pesquet"]),
                .init(mission: "Axiom Mission 1", launchDate: "2022-04-08", landingDate: "2022-04-25", crew: ["Michael López-Alegría", "Larry Connor", "Eytan Stibbe", "Mark Pathy"]),
                .init(mission: "Crew-6", launchDate: "2023-03-02", landingDate: "2023-09-04", crew: ["Stephen Bowen", "Warren Hoburg", "Sultan Al Neyadi", "Andreï Fediaïev"]),
                .init(mission: "Crew-8", launchDate: "2024-03-04", landingDate: "2024-10-25", crew: ["Matthew Dominick", "Michael Barratt", "Jeanette Epps", "Alexandre Grebionkine"]),
                .init(mission: "Crew-11", launchDate: "2025-08-01", landingDate: "2026-01-15", crew: ["Zena Cardman", "Michael Fincke", "Kimiya Yui", "Oleg Platonov"])
            ]
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
            firstFlight: "2020-11-16",
            lastFlight: "2025-04-01",
            nextFlight: nil,
            flightHistory: [
                .init(mission: "Crew-1", launchDate: "2020-11-16", landingDate: "2021-05-02", crew: ["Michael Hopkins", "Victor Glover", "Soichi Noguchi", "Shannon Walker"]),
                .init(mission: "Inspiration4", launchDate: "2021-09-16", landingDate: "2021-09-18", crew: ["Jared Isaacman", "Sian Proctor", "Hayley Arceneaux", "Christopher Sembroski"]),
                .init(mission: "Polaris Dawn", launchDate: "2024-09-10", landingDate: "2024-09-15", crew: ["Jared Isaacman", "Scott Poteet", "Sarah Gillis", "Anna Menon"]),
                .init(mission: "Fram2", launchDate: "2025-04-01", landingDate: "2025-04-04", crew: ["Jannicke Mikkelsen", "Rabea Rogge", "Chun Wang", "Eric Philips"])
            ]
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
                .init(label: "Crew-3, Crew-5, Crew-7, Crew-10", kind: .neutral),
                .init(label: "4 ISS rotation missions", kind: .ok)
            ],
            firstFlight: "2021-11-11",
            lastFlight: "2025-03-12",
            nextFlight: nil,
            flightHistory: [
                .init(mission: "Crew-3", launchDate: "2021-11-11", landingDate: "2022-05-06", crew: ["Raja Chari", "Thomas Marshburn", "Kayla Barron", "Matthias Maurer"]),
                .init(mission: "Crew-5", launchDate: "2022-10-05", landingDate: "2023-03-12", crew: ["Nicole Mann", "Josh Cassada", "Kōichi Wakata", "Anna Kikina"]),
                .init(mission: "Crew-7", launchDate: "2023-08-26", landingDate: "2024-03-12", crew: ["Jasmin Moghbeli", "Andreas Mogensen", "Satoshi Furukawa", "Konstantin Borissov"]),
                .init(mission: "Crew-10", launchDate: "2025-03-12", landingDate: "2025-08-09", crew: ["Anne McClain", "Nichole Ayers", "Takuya Onishi", "Kirill Peskov"])
            ]
        ),
        CrewDragonReference(
            id: "freedom",
            name: "Freedom",
            serial: "C212",
            variant: "Crew Dragon 2",
            missions: 5,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "Crew-4, Ax-2, Ax-3, Crew-9, Crew-12", kind: .neutral),
                .init(label: "5 ISS missions flown", kind: .ok)
            ],
            firstFlight: "2022-04-27",
            lastFlight: "2026-02-13",
            nextFlight: nil,
            flightHistory: [
                .init(
                    mission: "Crew-4",
                    launchDate: "2022-04-27",
                    landingDate: "2022-10-14",
                    crew: ["Kjell Lindgren", "Robert Hines", "Samantha Cristoforetti", "Jessica Watkins"]
                ),
                .init(
                    mission: "Axiom Mission 2",
                    launchDate: "2023-05-21",
                    landingDate: "2023-05-31",
                    crew: ["Peggy Whitson", "John Shoffner", "Ali Al-Qarni", "Rayyanah Barnawi"]
                ),
                .init(
                    mission: "Axiom Mission 3",
                    launchDate: "2024-01-18",
                    landingDate: "2024-02-09",
                    crew: ["Michael López-Alegría", "Walter Villadei", "Alper Gezeravcı", "Marcus Wandt"]
                ),
                .init(
                    mission: "Crew-9",
                    launchDate: "2024-09-28",
                    landingDate: "2025-03-18",
                    crew: ["Nick Hague", "Alexandre Gorbounov", "Barry Wilmore", "Sunita Williams"]
                ),
                .init(
                    mission: "Crew-12",
                    launchDate: "2026-02-13",
                    landingDate: nil,
                    crew: ["Jessica Meir", "Jack Hathaway", "Sophie Adenot", "Andreï Fediaïev"]
                )
            ]
        ),
        CrewDragonReference(
            id: "grace",
            name: "Grace",
            serial: "C213",
            variant: "Crew Dragon 2",
            missions: 1,
            crewCapacity: "4 (up to 7)",
            status: "Active",
            imageURL: URL(string: "https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_crew_drag_image_20200504074435.jpeg"),
            wikipediaTitle: "SpaceX Dragon 2",
            palmares: [
                .init(label: "5th and final Crew Dragon capsule", kind: .neutral),
                .init(label: "Axiom Mission 4", kind: .ok)
            ],
            firstFlight: "2025-06-25",
            lastFlight: "2025-06-25",
            nextFlight: nil,
            flightHistory: [
                .init(mission: "Axiom Mission 4", launchDate: "2025-06-25", landingDate: "2025-07-15", crew: ["Peggy Whitson", "Shubhanshu Shukla", "Sławosz Uznański-Wiśniewski", "Tibor Kapu"])
            ]
        ),
    ]

    static let cargoDragons: [CargoDragonReference] = [
        CargoDragonReference(
            id: "c208",
            serial: "C208",
            status: "Active",
            firstFlight: "2020-12-06",
            missions: 5,
            flightHistory: [
                .init(mission: "CRS-21", launchDate: "2020-12-06", landingDate: "2021-01-14", crew: []),
                .init(mission: "CRS-23", launchDate: "2021-08-29", landingDate: "2021-10-01", crew: []),
                .init(mission: "CRS-25", launchDate: "2022-07-15", landingDate: "2022-08-20", crew: []),
                .init(mission: "CRS-28", launchDate: "2023-06-05", landingDate: "2023-06-30", crew: []),
                .init(mission: "CRS-31", launchDate: "2024-11-05", landingDate: "2024-12-17", crew: [])
            ]
        ),
        CargoDragonReference(
            id: "c209",
            serial: "C209",
            status: "Active",
            firstFlight: "2021-03-15",
            missions: 6,
            flightHistory: [
                .init(mission: "CRS-22", launchDate: "2021-03-15", landingDate: "2021-04-20", crew: []),
                .init(mission: "CRS-24", launchDate: "2021-12-21", landingDate: "2022-01-24", crew: []),
                .init(mission: "CRS-27", launchDate: "2023-03-15", landingDate: "2023-04-15", crew: []),
                .init(mission: "CRS-30", launchDate: "2024-03-21", landingDate: "2024-04-30", crew: []),
                .init(mission: "CRS-32", launchDate: "2025-04-21", landingDate: "2025-05-25", crew: []),
                .init(mission: "CRS-34", launchDate: "2026-05-15", landingDate: nil, crew: [])
            ]
        ),
        CargoDragonReference(
            id: "c211",
            serial: "C211",
            status: "Active",
            firstFlight: "2022-11-26",
            missions: 3,
            flightHistory: [
                .init(mission: "CRS-26", launchDate: "2022-11-26", landingDate: "2023-01-11", crew: []),
                .init(mission: "CRS-29", launchDate: "2023-11-10", landingDate: "2023-12-22", crew: []),
                .init(mission: "CRS-33", launchDate: "2025-08-24", landingDate: "2026-02-27", crew: [])
            ]
        ),
    ]
}
