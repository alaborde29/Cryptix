import Foundation

/// Dependency injection container for the application
@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()

    // MARK: - Repositories
    lazy var currencyRepository: CurrencyRepository = {
        CurrencyRepository(provider: exchangeRateProvider, cache: cacheManager)
    }()

    lazy var cryptoRepository: CryptoRepository = {
        CryptoRepository(provider: cryptoProvider, cache: cacheManager)
    }()

    // MARK: - Providers
    lazy var exchangeRateProvider: ExchangeRateProviding = {
        ExchangeRateProvider(apiClient: .shared)
    }()

    lazy var cryptoProvider: CryptoProviding = {
        CryptoProvider(apiClient: .shared)
    }()

    // MARK: - Utilities
    lazy var cacheManager: CacheManager = {
        CacheManager.shared
    }()

    lazy var networkMonitor: NetworkMonitor = {
        NetworkMonitor.shared
    }()

    // MARK: - ViewModels
    func makeCurrencyConverterViewModel() -> CurrencyConverterViewModel {
        CurrencyConverterViewModel(repository: currencyRepository)
    }

    func makeCryptoViewerViewModel() -> CryptoViewerViewModel {
        CryptoViewerViewModel(repository: cryptoRepository)
    }

    private init() {}
}

/// Environment key for dependency container
import SwiftUI

struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer.shared
}

extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
