import Foundation

/// Response from the ExchangeRate-API
struct ExchangeRateResponse: Codable {
    let base: String
    let date: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case base
        case date
        case rates
    }
}
