import Foundation

/// API endpoints for the application
enum APIEndpoint {
    // MARK: - Currency Exchange
    case exchangeRates(base: String)

    // MARK: - Cryptocurrency
    case cryptoPrices(ids: [String], vsCurrency: String)
    case cryptoPriceHistory(id: String, vsCurrency: String, days: Int)

    var url: URL? {
        switch self {
        case .exchangeRates(let base):
            return URL(string: "https://api.exchangerate-api.com/v4/latest/\(base)")

        case .cryptoPrices(let ids, let vsCurrency):
            var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/markets")
            components?.queryItems = [
                URLQueryItem(name: "vs_currency", value: vsCurrency),
                URLQueryItem(name: "ids", value: ids.joined(separator: ",")),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "sparkline", value: "false"),
                URLQueryItem(name: "price_change_percentage", value: "24h")
            ]
            return components?.url

        case .cryptoPriceHistory(let id, let vsCurrency, let days):
            var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/\(id)/market_chart")
            components?.queryItems = [
                URLQueryItem(name: "vs_currency", value: vsCurrency),
                URLQueryItem(name: "days", value: String(days))
            ]
            return components?.url
        }
    }

    var method: String {
        return "GET"
    }

    var headers: [String: String] {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "User-Agent": "Cryptix/1.0"
        ]
    }
}

/// Default cryptocurrency IDs for top 10 coins
extension APIEndpoint {
    static let defaultCryptoIds = [
        "bitcoin",
        "ethereum",
        "solana",
        "ripple",
        "cardano",
        "binancecoin",
        "dogecoin",
        "polkadot",
        "avalanche-2",
        "matic-network"
    ]
}
