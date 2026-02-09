import Foundation

/// Represents a cryptocurrency with price data
struct Cryptocurrency: Identifiable, Codable, Equatable {
    let id: String
    let symbol: String
    let name: String
    let imageURL: String
    let currentPrice: Double
    let priceChangePercentage24h: Double

    var formattedPrice: String {
        currentPrice.asCryptoPrice()
    }

    var formattedPriceWithSymbol: String {
        "$\(formattedPrice)"
    }

    var formattedChange: String {
        priceChangePercentage24h.asPercentage(decimals: 2, includeSign: true)
    }

    var isPositiveChange: Bool {
        priceChangePercentage24h >= 0
    }

    var symbolUppercased: String {
        symbol.uppercased()
    }
}

extension Cryptocurrency {
    static let preview = Cryptocurrency(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        imageURL: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
        currentPrice: 43250.50,
        priceChangePercentage24h: 2.35
    )

    static let previewList: [Cryptocurrency] = [
        Cryptocurrency(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            imageURL: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
            currentPrice: 43250.50,
            priceChangePercentage24h: 2.35
        ),
        Cryptocurrency(
            id: "ethereum",
            symbol: "eth",
            name: "Ethereum",
            imageURL: "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
            currentPrice: 2280.75,
            priceChangePercentage24h: -1.15
        ),
        Cryptocurrency(
            id: "solana",
            symbol: "sol",
            name: "Solana",
            imageURL: "https://assets.coingecko.com/coins/images/4128/large/solana.png",
            currentPrice: 98.45,
            priceChangePercentage24h: 5.82
        )
    ]
}
