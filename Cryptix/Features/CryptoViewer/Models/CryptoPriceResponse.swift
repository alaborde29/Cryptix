import Foundation

/// Response from CoinGecko API
struct CryptoPriceResponse: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24h: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }

    func toCryptocurrency() -> Cryptocurrency {
        Cryptocurrency(
            id: id,
            symbol: symbol,
            name: name,
            imageURL: image,
            currentPrice: currentPrice,
            priceChangePercentage24h: priceChangePercentage24h ?? 0
        )
    }
}
