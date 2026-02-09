import Foundation

/// Represents a currency with code, name, and symbol
struct Currency: Identifiable, Hashable, Codable {
    let code: String
    let name: String
    let symbol: String
    let flag: String

    var id: String { code }

    /// Common currencies
    static let usd = Currency(code: "USD", name: "US Dollar", symbol: "$", flag: "🇺🇸")
    static let eur = Currency(code: "EUR", name: "Euro", symbol: "€", flag: "🇪🇺")
    static let gbp = Currency(code: "GBP", name: "British Pound", symbol: "£", flag: "🇬🇧")
    static let jpy = Currency(code: "JPY", name: "Japanese Yen", symbol: "¥", flag: "🇯🇵")
    static let chf = Currency(code: "CHF", name: "Swiss Franc", symbol: "Fr", flag: "🇨🇭")
    static let cad = Currency(code: "CAD", name: "Canadian Dollar", symbol: "CA$", flag: "🇨🇦")
    static let aud = Currency(code: "AUD", name: "Australian Dollar", symbol: "A$", flag: "🇦🇺")
    static let cny = Currency(code: "CNY", name: "Chinese Yuan", symbol: "¥", flag: "🇨🇳")
    static let inr = Currency(code: "INR", name: "Indian Rupee", symbol: "₹", flag: "🇮🇳")
    static let mxn = Currency(code: "MXN", name: "Mexican Peso", symbol: "MX$", flag: "🇲🇽")
    static let brl = Currency(code: "BRL", name: "Brazilian Real", symbol: "R$", flag: "🇧🇷")
    static let krw = Currency(code: "KRW", name: "South Korean Won", symbol: "₩", flag: "🇰🇷")
    static let sgd = Currency(code: "SGD", name: "Singapore Dollar", symbol: "S$", flag: "🇸🇬")
    static let hkd = Currency(code: "HKD", name: "Hong Kong Dollar", symbol: "HK$", flag: "🇭🇰")
    static let nok = Currency(code: "NOK", name: "Norwegian Krone", symbol: "kr", flag: "🇳🇴")
    static let sek = Currency(code: "SEK", name: "Swedish Krona", symbol: "kr", flag: "🇸🇪")
    static let dkk = Currency(code: "DKK", name: "Danish Krone", symbol: "kr", flag: "🇩🇰")
    static let nzd = Currency(code: "NZD", name: "New Zealand Dollar", symbol: "NZ$", flag: "🇳🇿")
    static let zar = Currency(code: "ZAR", name: "South African Rand", symbol: "R", flag: "🇿🇦")
    static let rub = Currency(code: "RUB", name: "Russian Ruble", symbol: "₽", flag: "🇷🇺")
    static let thb = Currency(code: "THB", name: "Thai Baht", symbol: "฿", flag: "🇹🇭")
    static let pln = Currency(code: "PLN", name: "Polish Zloty", symbol: "zł", flag: "🇵🇱")
    static let aed = Currency(code: "AED", name: "UAE Dirham", symbol: "د.إ", flag: "🇦🇪")
    static let sar = Currency(code: "SAR", name: "Saudi Riyal", symbol: "﷼", flag: "🇸🇦")

    /// All available currencies
    static let all: [Currency] = [
        .usd, .eur, .gbp, .jpy, .chf, .cad, .aud, .cny, .inr, .mxn,
        .brl, .krw, .sgd, .hkd, .nok, .sek, .dkk, .nzd, .zar, .rub,
        .thb, .pln, .aed, .sar
    ]

    /// Find currency by code
    static func find(by code: String) -> Currency? {
        all.first { $0.code.uppercased() == code.uppercased() }
    }
}
