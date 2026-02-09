import Foundation

/// Response from CoinGecko market_chart API
struct CryptoPriceHistoryResponse: Codable {
    let prices: [[Double]] // [[timestamp, price], ...]

    func toPriceHistory() -> [PricePoint] {
        prices.compactMap { point in
            guard point.count >= 2 else { return nil }
            let timestamp = point[0] / 1000 // Convert ms to seconds
            let price = point[1]
            return PricePoint(date: Date(timeIntervalSince1970: timestamp), price: price)
        }
    }
}

/// A single price point for charting
struct PricePoint: Identifiable, Equatable, Codable {
    let id: UUID
    let date: Date
    let price: Double

    init(date: Date, price: Double) {
        self.id = UUID()
        self.date = date
        self.price = price
    }

    var formattedPrice: String {
        price.asCryptoPrice()
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

/// Time range options for price history
enum PriceHistoryRange: String, CaseIterable, Identifiable {
    case day = "24H"
    case week = "7D"
    case month = "30D"
    case threeMonths = "90D"
    case year = "1Y"

    var id: String { rawValue }

    var days: Int {
        switch self {
        case .day: return 1
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .year: return 365
        }
    }

    var cacheKey: String {
        rawValue.lowercased()
    }
}
