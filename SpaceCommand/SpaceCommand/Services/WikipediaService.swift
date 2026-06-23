import Foundation

struct WikiSummary: Decodable {
    let title: String?
    let extract: String?
    let thumbnail: WikiThumbnail?
    let contentUrls: WikiContentURLs?

    enum CodingKeys: String, CodingKey {
        case title, extract, thumbnail
        case contentUrls = "content_urls"
    }
}

struct WikiThumbnail: Decodable {
    let source: URL?
}

struct WikiContentURLs: Decodable {
    let desktop: WikiURLBundle?
}

struct WikiURLBundle: Decodable {
    let page: URL?
}

actor WikipediaService {
    static let shared = WikipediaService()
    private var cache: [String: WikiSummary] = [:]

    func summary(title: String, language: String) async -> WikiSummary? {
        let key = "\(language):\(title)"
        if let cached = cache[key] { return cached }
        guard let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "https://\(language).wikipedia.org/api/rest_v1/page/summary/\(encoded)") else {
            return nil
        }
        var req = URLRequest(url: url)
        req.timeoutInterval = 15
        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            let summary = try JSONDecoder().decode(WikiSummary.self, from: data)
            cache[key] = summary
            return summary
        } catch {
            return nil
        }
    }
}
