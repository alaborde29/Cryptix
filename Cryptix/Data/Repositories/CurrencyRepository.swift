import Foundation

/// Repository for currency exchange data with caching
final class CurrencyRepository {
    private let provider: ExchangeRateProviding
    private let cache: CacheManager

    init(provider: ExchangeRateProviding = ExchangeRateProvider(), cache: CacheManager = .shared) {
        self.provider = provider
        self.cache = cache
    }

    // MARK: - Exchange Rates

    func getExchangeRates(base: String, forceRefresh: Bool = false) async throws -> ExchangeRateResponse {
        let cacheKey = CacheManager.CacheKey.exchangeRates(base: base)

        // Return cached data if available and not forcing refresh
        if !forceRefresh,
           let cached: ExchangeRateResponse = cache.load(ExchangeRateResponse.self, forKey: cacheKey) {
            return cached
        }

        do {
            let response = try await provider.fetchRates(base: base)
            cache.save(response, forKey: cacheKey, duration: CacheManager.CacheDuration.exchangeRates)
            return response
        } catch {
            // On error, try to return stale cached data
            if let stale: ExchangeRateResponse = cache.loadIgnoringExpiry(ExchangeRateResponse.self, forKey: cacheKey) {
                return stale
            }
            throw error
        }
    }

    func convert(amount: Double, from: String, to: String) async throws -> ConversionResult {
        let rates = try await getExchangeRates(base: from)

        guard let rate = rates.rates[to] else {
            throw ConversionError.unsupportedCurrency(to)
        }

        let convertedAmount = amount * rate

        return ConversionResult(
            fromCurrency: from,
            toCurrency: to,
            fromAmount: amount,
            toAmount: convertedAmount,
            rate: rate,
            timestamp: Date()
        )
    }

    // MARK: - Conversion History

    func saveConversion(_ result: ConversionResult) {
        var history = getConversionHistory()
        history.insert(result, at: 0)

        // Keep only last 20 conversions
        if history.count > 20 {
            history = Array(history.prefix(20))
        }

        cache.save(history, forKey: CacheManager.CacheKey.conversionHistory, duration: CacheManager.CacheDuration.permanent)
    }

    func getConversionHistory() -> [ConversionResult] {
        cache.load([ConversionResult].self, forKey: CacheManager.CacheKey.conversionHistory) ?? []
    }

    func clearHistory() {
        cache.remove(forKey: CacheManager.CacheKey.conversionHistory)
    }
}

enum ConversionError: LocalizedError {
    case unsupportedCurrency(String)

    var errorDescription: String? {
        switch self {
        case .unsupportedCurrency(let code):
            return "Currency \(code) is not supported."
        }
    }
}
