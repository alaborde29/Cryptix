import Foundation

/// Manages caching of data with expiration
final class CacheManager {
    static let shared = CacheManager()

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {}

    // MARK: - Cache Keys
    enum CacheKey {
        static func exchangeRates(base: String) -> String {
            "cache.rates.\(base)"
        }
        static let cryptoPrices = "cache.crypto"
        static let conversionHistory = "history.conversions"
    }

    // MARK: - Cache Duration
    enum CacheDuration {
        static let exchangeRates: TimeInterval = 3600 // 1 hour
        static let cryptoPrices: TimeInterval = 300 // 5 minutes (to avoid rate limits)
        static let permanent: TimeInterval = .infinity
    }

    // MARK: - Cache Entry
    private struct CacheEntry<T: Codable>: Codable {
        let data: T
        let timestamp: Date
        let duration: TimeInterval

        var isExpired: Bool {
            guard duration != .infinity else { return false }
            return Date().timeIntervalSince(timestamp) > duration
        }
    }

    // MARK: - Public Methods

    func save<T: Codable>(_ data: T, forKey key: String, duration: TimeInterval) {
        let entry = CacheEntry(data: data, timestamp: Date(), duration: duration)
        do {
            let encoded = try encoder.encode(entry)
            defaults.set(encoded, forKey: key)
        } catch {
            print("Cache save error: \(error)")
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }

        do {
            let entry = try decoder.decode(CacheEntry<T>.self, from: data)
            if entry.isExpired {
                remove(forKey: key)
                return nil
            }
            return entry.data
        } catch {
            print("Cache load error: \(error)")
            return nil
        }
    }

    func loadIgnoringExpiry<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }

        do {
            let entry = try decoder.decode(CacheEntry<T>.self, from: data)
            return entry.data
        } catch {
            print("Cache load error: \(error)")
            return nil
        }
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func clearAll() {
        let keys = defaults.dictionaryRepresentation().keys.filter { $0.hasPrefix("cache.") }
        keys.forEach { defaults.removeObject(forKey: $0) }
    }

    func isExpired(forKey key: String) -> Bool {
        guard let data = defaults.data(forKey: key) else { return true }

        do {
            let entry = try decoder.decode(CacheEntry<EmptyData>.self, from: data)
            return entry.isExpired
        } catch {
            return true
        }
    }

    private struct EmptyData: Codable {}
}
