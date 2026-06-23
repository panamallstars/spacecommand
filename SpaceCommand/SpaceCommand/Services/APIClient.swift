import Foundation

enum APIError: Error {
    case rateLimited
    case network(String)
    case decoding(String)
}

actor APIClient {
    static let shared = APIClient()

    private let base = URL(string: "https://ll.thespacedevs.com/2.3.0")!
    private let baseFallback = URL(string: "https://lldev.thespacedevs.com/2.3.0")!
    private let session: URLSession

    private var cachedLaunches: [Launch]?
    private var cacheTimestamp: Date?
    private let cacheTTL: TimeInterval = 300

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

    func upcomingLaunches() async throws -> [Launch] {
        let path = "/launches/upcoming/?search=SpaceX&limit=40&mode=detailed"

        // Check if cache is still valid
        if let cached = cachedLaunches, let timestamp = cacheTimestamp,
           Date().timeIntervalSince(timestamp) < cacheTTL {
            return cached
        }

        // Try primary endpoint with retry
        for attempt in 1...2 {
            do {
                let result = try await fetchLaunches(base: base, path: path)
                cachedLaunches = result
                cacheTimestamp = Date()
                return result
            } catch {
                if attempt < 2 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
        }

        // Try fallback endpoint
        do {
            let result = try await fetchLaunches(base: baseFallback, path: path)
            cachedLaunches = result
            cacheTimestamp = Date()
            return result
        } catch {
            // If both endpoints fail, return cached data if available (even if expired)
            if let cached = cachedLaunches {
                return cached
            }
            throw error
        }
    }

    private func fetchLaunches(base: URL, path: String) async throws -> [Launch] {
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
            let envelope = try decoder.decode(LaunchResponse.self, from: data)
            let results = envelope.results.filter { ($0.lsp?.name ?? "").contains("SpaceX") }
            return results
        } catch {
            throw APIError.decoding(String(describing: error))
        }
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
