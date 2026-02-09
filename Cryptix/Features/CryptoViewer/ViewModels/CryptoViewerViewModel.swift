import Foundation

/// ViewModel for cryptocurrency viewer
@Observable
@MainActor
final class CryptoViewerViewModel {
    // MARK: - Properties

    var cryptocurrencies: [Cryptocurrency] = []
    var isLoading = false
    var isRefreshing = false
    var error: String?
    var lastUpdated: Date?

    private let repository: CryptoRepository
    private var refreshTask: Task<Void, Never>?
    private var autoRefreshTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var formattedLastUpdated: String? {
        guard let lastUpdated else { return nil }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return "Updated \(formatter.localizedString(for: lastUpdated, relativeTo: Date()))"
    }

    var hasData: Bool {
        !cryptocurrencies.isEmpty
    }

    // MARK: - Initialization

    init(repository: CryptoRepository) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func loadPrices() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            cryptocurrencies = try await repository.getCryptoPrices()
            lastUpdated = Date()
        } catch {
            print("CryptoViewer Error: \(error)")
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        guard !isRefreshing else { return }

        isRefreshing = true
        error = nil

        do {
            cryptocurrencies = try await repository.refreshPrices()
            lastUpdated = Date()
            HapticManager.success()
        } catch {
            self.error = error.localizedDescription
            HapticManager.error()
        }

        isRefreshing = false
    }

    func startAutoRefresh() {
        stopAutoRefresh()

        autoRefreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 300_000_000_000) // 5 minutes

                guard !Task.isCancelled else { break }

                do {
                    let prices = try await repository.getCryptoPrices(forceRefresh: true)
                    await MainActor.run {
                        self.cryptocurrencies = prices
                        self.lastUpdated = Date()
                    }
                } catch {
                    // Silently fail for auto-refresh
                    print("Auto-refresh failed: \(error)")
                }
            }
        }
    }

    func stopAutoRefresh() {
        autoRefreshTask?.cancel()
        autoRefreshTask = nil
    }

    // MARK: - Sorting

    func sortByPrice(ascending: Bool = false) {
        cryptocurrencies.sort {
            ascending ? $0.currentPrice < $1.currentPrice : $0.currentPrice > $1.currentPrice
        }
    }

    func sortByChange(ascending: Bool = false) {
        cryptocurrencies.sort {
            ascending ? $0.priceChangePercentage24h < $1.priceChangePercentage24h : $0.priceChangePercentage24h > $1.priceChangePercentage24h
        }
    }

    func sortByName() {
        cryptocurrencies.sort { $0.name < $1.name }
    }
}
