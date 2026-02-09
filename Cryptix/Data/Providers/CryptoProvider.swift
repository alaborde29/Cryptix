import Foundation

/// Protocol for cryptocurrency data provider
protocol CryptoProviding {
    func fetchPrices(ids: [String], vsCurrency: String) async throws -> [CryptoPriceResponse]
    func fetchPriceHistory(id: String, vsCurrency: String, days: Int) async throws -> CryptoPriceHistoryResponse
}

/// CoinGecko implementation
final class CryptoProvider: CryptoProviding {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchPrices(ids: [String], vsCurrency: String) async throws -> [CryptoPriceResponse] {
        try await apiClient.fetch(
            [CryptoPriceResponse].self,
            from: .cryptoPrices(ids: ids, vsCurrency: vsCurrency)
        )
    }

    func fetchPriceHistory(id: String, vsCurrency: String, days: Int) async throws -> CryptoPriceHistoryResponse {
        try await apiClient.fetch(
            CryptoPriceHistoryResponse.self,
            from: .cryptoPriceHistory(id: id, vsCurrency: vsCurrency, days: days)
        )
    }
}

/// Mock provider for previews and testing
final class MockCryptoProvider: CryptoProviding {
    func fetchPrices(ids: [String], vsCurrency: String) async throws -> [CryptoPriceResponse] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            CryptoPriceResponse(
                id: "bitcoin",
                symbol: "btc",
                name: "Bitcoin",
                image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
                currentPrice: 43250.50,
                priceChangePercentage24h: 2.35
            ),
            CryptoPriceResponse(
                id: "ethereum",
                symbol: "eth",
                name: "Ethereum",
                image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
                currentPrice: 2280.75,
                priceChangePercentage24h: -1.15
            ),
            CryptoPriceResponse(
                id: "solana",
                symbol: "sol",
                name: "Solana",
                image: "https://assets.coingecko.com/coins/images/4128/large/solana.png",
                currentPrice: 98.45,
                priceChangePercentage24h: 5.82
            ),
            CryptoPriceResponse(
                id: "ripple",
                symbol: "xrp",
                name: "XRP",
                image: "https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png",
                currentPrice: 0.62,
                priceChangePercentage24h: -0.45
            ),
            CryptoPriceResponse(
                id: "cardano",
                symbol: "ada",
                name: "Cardano",
                image: "https://assets.coingecko.com/coins/images/975/large/cardano.png",
                currentPrice: 0.52,
                priceChangePercentage24h: 1.25
            ),
            CryptoPriceResponse(
                id: "binancecoin",
                symbol: "bnb",
                name: "BNB",
                image: "https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png",
                currentPrice: 312.80,
                priceChangePercentage24h: 0.85
            ),
            CryptoPriceResponse(
                id: "dogecoin",
                symbol: "doge",
                name: "Dogecoin",
                image: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png",
                currentPrice: 0.082,
                priceChangePercentage24h: 3.45
            ),
            CryptoPriceResponse(
                id: "polkadot",
                symbol: "dot",
                name: "Polkadot",
                image: "https://assets.coingecko.com/coins/images/12171/large/polkadot.png",
                currentPrice: 7.85,
                priceChangePercentage24h: -2.10
            ),
            CryptoPriceResponse(
                id: "avalanche-2",
                symbol: "avax",
                name: "Avalanche",
                image: "https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png",
                currentPrice: 35.20,
                priceChangePercentage24h: 4.15
            ),
            CryptoPriceResponse(
                id: "matic-network",
                symbol: "matic",
                name: "Polygon",
                image: "https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png",
                currentPrice: 0.78,
                priceChangePercentage24h: 1.95
            )
        ]
    }

    func fetchPriceHistory(id: String, vsCurrency: String, days: Int) async throws -> CryptoPriceHistoryResponse {
        try await Task.sleep(nanoseconds: 300_000_000)
        return CryptoPriceHistoryResponse(prices: generateMockPrices(days: days))
    }

    private func generateMockPrices(days: Int) -> [[Double]] {
        let now = Date()
        let pointCount = days <= 1 ? 24 : days
        let interval: TimeInterval = days <= 1 ? 3600 : 86400

        var prices: [[Double]] = []
        var basePrice = 45000.0

        for i in 0..<pointCount {
            let timestamp = now.addingTimeInterval(-Double(pointCount - i) * interval).timeIntervalSince1970 * 1000
            let randomChange = Double.random(in: -0.03...0.03)
            basePrice *= (1 + randomChange)
            prices.append([timestamp, basePrice])
        }

        return prices
    }
}
