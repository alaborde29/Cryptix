import Foundation

/// Result of a currency conversion
struct ConversionResult: Identifiable, Codable, Equatable {
    let id: UUID
    let fromCurrency: String
    let toCurrency: String
    let fromAmount: Double
    let toAmount: Double
    let rate: Double
    let timestamp: Date

    init(
        id: UUID = UUID(),
        fromCurrency: String,
        toCurrency: String,
        fromAmount: Double,
        toAmount: Double,
        rate: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.fromAmount = fromAmount
        self.toAmount = toAmount
        self.rate = rate
        self.timestamp = timestamp
    }

    var formattedFromAmount: String {
        fromAmount.formatted(decimals: 2)
    }

    var formattedToAmount: String {
        toAmount.formatted(decimals: 2)
    }

    var formattedRate: String {
        "1 \(fromCurrency) = \(rate.formatted(decimals: 4)) \(toCurrency)"
    }

    var formattedTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }

    var fromCurrencyInfo: Currency? {
        Currency.find(by: fromCurrency)
    }

    var toCurrencyInfo: Currency? {
        Currency.find(by: toCurrency)
    }
}
