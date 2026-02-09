import Foundation

/// ViewModel for currency conversion
@Observable
@MainActor
final class CurrencyConverterViewModel {
    // MARK: - Properties

    var inputAmount: String = "0"
    var sourceCurrency: Currency = .usd
    var targetCurrency: Currency = .eur
    var convertedAmount: String = "0"
    var exchangeRate: Double = 0
    var isLoading = false
    var error: String?
    var conversionHistory: [ConversionResult] = []

    var showSourcePicker = false
    var showTargetPicker = false
    var showHistory = false

    private let repository: CurrencyRepository
    private var conversionTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var formattedRate: String {
        guard exchangeRate > 0 else { return "" }
        return "1 \(sourceCurrency.code) = \(exchangeRate.formatted(decimals: 4)) \(targetCurrency.code)"
    }

    var canConvert: Bool {
        guard let amount = inputAmount.toDouble() else { return false }
        return amount > 0
    }

    // MARK: - Initialization

    init(repository: CurrencyRepository) {
        self.repository = repository
        loadHistory()
    }

    // MARK: - Keypad Actions

    func handleKeyTap(_ key: KeypadKey) {
        switch key {
        case .digit(let digit):
            appendDigit(digit)
        case .decimal:
            appendDecimal()
        case .delete:
            deleteLastCharacter()
        }

        performConversion()
    }

    private func appendDigit(_ digit: String) {
        if inputAmount == "0" {
            inputAmount = digit
        } else if inputAmount.count < 15 {
            inputAmount += digit
        }
    }

    private func appendDecimal() {
        guard !inputAmount.contains(".") else { return }
        inputAmount += "."
    }

    private func deleteLastCharacter() {
        if inputAmount.count > 1 {
            inputAmount.removeLast()
        } else {
            inputAmount = "0"
        }
    }

    func clearInput() {
        inputAmount = "0"
        convertedAmount = "0"
    }

    // MARK: - Currency Actions

    func swapCurrencies() {
        let temp = sourceCurrency
        sourceCurrency = targetCurrency
        targetCurrency = temp

        // Swap amounts
        if let converted = convertedAmount.toDouble(), converted > 0 {
            inputAmount = convertedAmount.replacingOccurrences(of: ",", with: "")
        }

        performConversion()
    }

    func setSourceCurrency(_ currency: Currency) {
        sourceCurrency = currency
        performConversion()
    }

    func setTargetCurrency(_ currency: Currency) {
        targetCurrency = currency
        performConversion()
    }

    // MARK: - Conversion

    func performConversion() {
        conversionTask?.cancel()

        guard let amount = inputAmount.toDouble(), amount > 0 else {
            convertedAmount = "0"
            exchangeRate = 0
            return
        }

        conversionTask = Task {
            await convert(amount: amount)
        }
    }

    private func convert(amount: Double) async {
        isLoading = true
        error = nil

        do {
            let result = try await repository.convert(
                amount: amount,
                from: sourceCurrency.code,
                to: targetCurrency.code
            )

            guard !Task.isCancelled else { return }

            exchangeRate = result.rate
            convertedAmount = result.toAmount.formatted(decimals: 2)
        } catch {
            guard !Task.isCancelled else { return }
            self.error = error.localizedDescription
            convertedAmount = "Error"
        }

        isLoading = false
    }

    func saveCurrentConversion() {
        guard let fromAmount = inputAmount.toDouble(),
              let toAmount = convertedAmount.toDouble(),
              fromAmount > 0, toAmount > 0 else { return }

        let result = ConversionResult(
            fromCurrency: sourceCurrency.code,
            toCurrency: targetCurrency.code,
            fromAmount: fromAmount,
            toAmount: toAmount,
            rate: exchangeRate
        )

        repository.saveConversion(result)
        loadHistory()
        HapticManager.success()
    }

    // MARK: - History

    func loadHistory() {
        conversionHistory = repository.getConversionHistory()
    }

    func clearHistory() {
        repository.clearHistory()
        conversionHistory = []
    }

    func restoreConversion(_ result: ConversionResult) {
        if let from = Currency.find(by: result.fromCurrency) {
            sourceCurrency = from
        }
        if let to = Currency.find(by: result.toCurrency) {
            targetCurrency = to
        }
        inputAmount = String(result.fromAmount)
        performConversion()
    }

    // MARK: - Refresh

    func refresh() async {
        guard let amount = inputAmount.toDouble(), amount > 0 else { return }

        isLoading = true
        error = nil

        do {
            let result = try await repository.convert(
                amount: amount,
                from: sourceCurrency.code,
                to: targetCurrency.code
            )

            exchangeRate = result.rate
            convertedAmount = result.toAmount.formatted(decimals: 2)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
