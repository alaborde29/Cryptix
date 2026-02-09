import Foundation

/// Repository for cryptocurrency data with caching
final class CryptoRepository {
    private let provider: CryptoProviding
    private let cache: CacheManager

    init(provider: CryptoProviding = CryptoProvider(), cache: CacheManager = .shared) {
        self.provider = provider
        self.cache = cache
    }

    // MARK: - Crypto Prices

    func getCryptoPrices(
        ids: [String] = APIEndpoint.defaultCryptoIds,
        vsCurrency: String = "usd",
        forceRefresh: Bool = false
    ) async throws -> [Cryptocurrency] {
        let cacheKey = CacheManager.CacheKey.cryptoPrices

        // Return cached data if available and not forcing refresh
        if !forceRefresh,
           let cached: [Cryptocurrency] = cache.load([Cryptocurrency].self, forKey: cacheKey) {
            return cached
        }

        do {
            let responses = try await provider.fetchPrices(ids: ids, vsCurrency: vsCurrency)
            let cryptocurrencies = responses.map { $0.toCryptocurrency() }
            cache.save(cryptocurrencies, forKey: cacheKey, duration: CacheManager.CacheDuration.cryptoPrices)
            return cryptocurrencies
        } catch {
            // On error, try to return stale cached data
            if let stale: [Cryptocurrency] = cache.loadIgnoringExpiry([Cryptocurrency].self, forKey: cacheKey) {
                return stale
            }
            // Fallback to demo data if no cache and API failed
            print("Using demo data due to API error: \(error)")
            return Self.demoData
        }
    }

    // MARK: - Demo Data (fallback when API rate limited)

    private static let demoData: [Cryptocurrency] = [
        Cryptocurrency(id: "bitcoin", symbol: "btc", name: "Bitcoin",
            imageURL: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
            currentPrice: 97250.00, priceChangePercentage24h: 1.85),
        Cryptocurrency(id: "ethereum", symbol: "eth", name: "Ethereum",
            imageURL: "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
            currentPrice: 2680.50, priceChangePercentage24h: -0.72),
        Cryptocurrency(id: "solana", symbol: "sol", name: "Solana",
            imageURL: "https://assets.coingecko.com/coins/images/4128/large/solana.png",
            currentPrice: 198.45, priceChangePercentage24h: 4.25),
        Cryptocurrency(id: "ripple", symbol: "xrp", name: "XRP",
            imageURL: "https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png",
            currentPrice: 2.48, priceChangePercentage24h: 2.15),
        Cryptocurrency(id: "cardano", symbol: "ada", name: "Cardano",
            imageURL: "https://assets.coingecko.com/coins/images/975/large/cardano.png",
            currentPrice: 0.82, priceChangePercentage24h: -1.35),
        Cryptocurrency(id: "binancecoin", symbol: "bnb", name: "BNB",
            imageURL: "https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png",
            currentPrice: 658.20, priceChangePercentage24h: 0.95),
        Cryptocurrency(id: "dogecoin", symbol: "doge", name: "Dogecoin",
            imageURL: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png",
            currentPrice: 0.328, priceChangePercentage24h: 5.82),
        Cryptocurrency(id: "polkadot", symbol: "dot", name: "Polkadot",
            imageURL: "https://assets.coingecko.com/coins/images/12171/large/polkadot.png",
            currentPrice: 5.42, priceChangePercentage24h: -2.10),
        Cryptocurrency(id: "avalanche-2", symbol: "avax", name: "Avalanche",
            imageURL: "https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png",
            currentPrice: 25.80, priceChangePercentage24h: 3.45),
        Cryptocurrency(id: "matic-network", symbol: "matic", name: "Polygon",
            imageURL: "https://assets.coingecko.com/coins/images/4713/large/polygon.png",
            currentPrice: 0.32, priceChangePercentage24h: 1.28)
    ]

    func getCryptocurrency(id: String, vsCurrency: String = "usd") async throws -> Cryptocurrency? {
        let all = try await getCryptoPrices(vsCurrency: vsCurrency)
        return all.first { $0.id == id }
    }

    func refreshPrices() async throws -> [Cryptocurrency] {
        try await getCryptoPrices(forceRefresh: true)
    }

    // MARK: - Price History

    func getPriceHistory(
        id: String,
        range: PriceHistoryRange,
        vsCurrency: String = "usd",
        forceRefresh: Bool = false
    ) async throws -> [PricePoint] {
        let cacheKey = "cache.history.\(id).\(range.cacheKey)"

        if !forceRefresh,
           let cached: [PricePoint] = cache.load([PricePoint].self, forKey: cacheKey) {
            return cached
        }

        do {
            let response = try await provider.fetchPriceHistory(id: id, vsCurrency: vsCurrency, days: range.days)
            let pricePoints = response.toPriceHistory()
            cache.save(pricePoints, forKey: cacheKey, duration: CacheManager.CacheDuration.cryptoPrices)
            return pricePoints
        } catch {
            if let stale: [PricePoint] = cache.loadIgnoringExpiry([PricePoint].self, forKey: cacheKey) {
                return stale
            }
            print("Using demo price history due to API error: \(error)")
            return Self.generateDemoPriceHistory(days: range.days)
        }
    }

    private static func generateDemoPriceHistory(days: Int) -> [PricePoint] {
        let now = Date()
        let pointCount = days <= 1 ? 24 : min(days, 90)
        let interval: TimeInterval = days <= 1 ? 3600 : 86400

        var points: [PricePoint] = []
        var basePrice = 45000.0

        for i in 0..<pointCount {
            let date = now.addingTimeInterval(-Double(pointCount - i) * interval)
            let randomChange = Double.random(in: -0.02...0.025)
            basePrice *= (1 + randomChange)
            points.append(PricePoint(date: date, price: basePrice))
        }

        return points
    }
}
