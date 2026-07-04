import Foundation

enum APIError: Error {
    case rateLimited
    case network(String)
    case decoding(String)
}

struct LaunchFeed {
    let launches: [Launch]
    let updatedAt: Date
    /// true when the data comes from a stale cache because the network failed
    let isStale: Bool
}

actor APIClient {
    static let shared = APIClient()

    private let base = URL(string: "https://ll.thespacedevs.com/2.3.0")!
    private let baseFallback = URL(string: "https://lldev.thespacedevs.com/2.3.0")!
    private let session: URLSession

    private var memoryCache: LaunchFeed?
    private let cacheTTL: TimeInterval = 300

    private let diskCacheURL: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("upcoming_launches.json")
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso2 = ISO8601DateFormatter()
        iso2.formatOptions = [.withInternetDateTime]
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd"
        d.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let s = try container.decode(String.self)
            if let date = iso.date(from: s) { return date }
            if let date = iso2.date(from: s) { return date }
            if let date = df.date(from: s) { return date }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(s)")
        }
        return d
    }()

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 120
        config.waitsForConnectivity = true
        session = URLSession(configuration: config)
    }

    func upcomingLaunches(forceRefresh: Bool = false) async throws -> LaunchFeed {
        let path = "/launches/upcoming/?search=SpaceX&limit=40&mode=detailed"

        if !forceRefresh {
            if let cached = memoryCache, Date().timeIntervalSince(cached.updatedAt) < cacheTTL {
                return cached
            }
            if memoryCache == nil, let disk = loadDiskCache(),
               Date().timeIntervalSince(disk.updatedAt) < cacheTTL {
                memoryCache = disk
                return disk
            }
        }

        // Try primary endpoint with retry
        for attempt in 1...2 {
            do {
                return try await fetchAndStore(base: base, path: path)
            } catch {
                if attempt < 2 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
        }

        // Try fallback endpoint
        do {
            return try await fetchAndStore(base: baseFallback, path: path)
        } catch {
            // Both endpoints failed: serve stale cache (memory, then disk) if available
            if let cached = memoryCache ?? loadDiskCache() {
                let stale = LaunchFeed(launches: cached.launches, updatedAt: cached.updatedAt, isStale: true)
                memoryCache = stale
                return stale
            }
            throw error
        }
    }

    private func fetchAndStore(base: URL, path: String) async throws -> LaunchFeed {
        let (launches, raw) = try await fetchLaunches(base: base, path: path)
        let feed = LaunchFeed(launches: launches, updatedAt: Date(), isStale: false)
        memoryCache = feed
        saveDiskCache(raw)
        return feed
    }

    private func fetchLaunches(base: URL, path: String) async throws -> ([Launch], Data) {
        guard let url = URL(string: base.absoluteString + path) else {
            throw APIError.network("bad url")
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
        req.timeoutInterval = 60
        req.cachePolicy = .useProtocolCachePolicy

        let (data, response) = try await session.data(for: req)

        if let http = response as? HTTPURLResponse {
            if http.statusCode == 429 { throw APIError.rateLimited }
            guard (200...299).contains(http.statusCode) else {
                throw APIError.network("HTTP \(http.statusCode)")
            }
        }

        do {
            let launches = try decodeLaunches(data)
            return (launches, data)
        } catch {
            throw APIError.decoding(String(describing: error))
        }
    }

    private func decodeLaunches(_ data: Data) throws -> [Launch] {
        let envelope = try decoder.decode(LaunchResponse.self, from: data)
        return envelope.results.filter { ($0.lsp?.name ?? "").contains("SpaceX") }
    }

    // MARK: - Disk cache

    private func saveDiskCache(_ raw: Data) {
        try? raw.write(to: diskCacheURL, options: .atomic)
    }

    private func loadDiskCache() -> LaunchFeed? {
        guard let data = try? Data(contentsOf: diskCacheURL),
              let launches = try? decodeLaunches(data),
              !launches.isEmpty else { return nil }
        let attrs = try? FileManager.default.attributesOfItem(atPath: diskCacheURL.path)
        let date = (attrs?[.modificationDate] as? Date) ?? .distantPast
        return LaunchFeed(launches: launches, updatedAt: date, isStale: false)
    }

    func boosterHistory(serial: String) async throws -> [LauncherHistoryItem] {
        let path = "/launches/?launcher_stages__launcher__serial_number=\(serial)&limit=50&mode=list&ordering=-net"
        guard let url = URL(string: base.absoluteString + path) else { return [] }
        var req = URLRequest(url: url)
        req.timeoutInterval = 20
        let (data, response) = try await URLSession.shared.data(for: req)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            return []
        }
        let env = try decoder.decode(BoosterHistoryEnvelope.self, from: data)
        return env.results
    }
}

struct BoosterHistoryEnvelope: Decodable {
    let results: [LauncherHistoryItem]
}

struct LauncherHistoryItem: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let net: Date?
    let status: LaunchStatus?
}
