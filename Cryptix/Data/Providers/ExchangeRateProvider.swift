import Foundation

/// Protocol for exchange rate data provider
protocol ExchangeRateProviding {
    func fetchRates(base: String) async throws -> ExchangeRateResponse
}

/// ExchangeRate-API implementation
final class ExchangeRateProvider: ExchangeRateProviding {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchRates(base: String) async throws -> ExchangeRateResponse {
        try await apiClient.fetch(
            ExchangeRateResponse.self,
            from: .exchangeRates(base: base)
        )
    }
}

/// Mock provider for previews and testing
final class MockExchangeRateProvider: ExchangeRateProviding {
    func fetchRates(base: String) async throws -> ExchangeRateResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        return ExchangeRateResponse(
            base: base,
            date: "2024-01-15",
            rates: [
                "USD": base == "USD" ? 1.0 : 1.08,
                "EUR": base == "EUR" ? 1.0 : 0.92,
                "GBP": base == "GBP" ? 1.0 : 0.79,
                "JPY": base == "JPY" ? 1.0 : 148.50,
                "CHF": base == "CHF" ? 1.0 : 0.87,
                "CAD": base == "CAD" ? 1.0 : 1.35,
                "AUD": base == "AUD" ? 1.0 : 1.52,
                "CNY": base == "CNY" ? 1.0 : 7.18,
                "INR": base == "INR" ? 1.0 : 83.10,
                "MXN": base == "MXN" ? 1.0 : 17.05
            ]
        )
    }
}
