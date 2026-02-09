import Foundation

extension Double {
    /// Format as currency with symbol
    func asCurrency(code: String = "USD", locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.locale = locale
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    /// Format as plain number with decimal places
    func formatted(decimals: Int = 2, groupingSeparator: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = groupingSeparator
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    /// Format as compact number (e.g., 1.2K, 3.4M)
    func asCompact() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""

        switch absValue {
        case 1_000_000_000_000...:
            return "\(sign)\(formatter.string(from: NSNumber(value: absValue / 1_000_000_000_000)) ?? "0")T"
        case 1_000_000_000...:
            return "\(sign)\(formatter.string(from: NSNumber(value: absValue / 1_000_000_000)) ?? "0")B"
        case 1_000_000...:
            return "\(sign)\(formatter.string(from: NSNumber(value: absValue / 1_000_000)) ?? "0")M"
        case 1_000...:
            return "\(sign)\(formatter.string(from: NSNumber(value: absValue / 1_000)) ?? "0")K"
        default:
            return formatted(decimals: 2)
        }
    }

    /// Format as percentage
    func asPercentage(decimals: Int = 2, includeSign: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals

        let formatted = formatter.string(from: NSNumber(value: abs(self))) ?? "0"
        let sign = includeSign ? (self >= 0 ? "+" : "-") : (self < 0 ? "-" : "")
        return "\(sign)\(formatted)%"
    }

    /// Format for crypto prices (handles small decimals)
    func asCryptoPrice() -> String {
        if self >= 1 {
            return formatted(decimals: 2)
        } else if self >= 0.01 {
            return formatted(decimals: 4)
        } else {
            return formatted(decimals: 8)
        }
    }
}

extension String {
    /// Parse string as Double, handling locale-specific decimal separators
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current

        if let number = formatter.number(from: self) {
            return number.doubleValue
        }

        // Fallback: try with standard decimal separator
        return Double(self.replacingOccurrences(of: ",", with: "."))
    }
}
