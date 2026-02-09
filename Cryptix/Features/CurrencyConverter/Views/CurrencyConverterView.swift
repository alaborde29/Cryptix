import SwiftUI

/// Main currency converter screen
struct CurrencyConverterView: View {
    @State private var viewModel: CurrencyConverterViewModel

    init(viewModel: CurrencyConverterViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            ColorPalette.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal, NeumorphicTheme.Spacing.md)
                    .padding(.top, NeumorphicTheme.Spacing.sm)

                Spacer()

                // Currency inputs with swap button
                currencyInputsView
                    .padding(.horizontal, NeumorphicTheme.Spacing.md)

                // Exchange rate
                if !viewModel.formattedRate.isEmpty {
                    rateView
                        .padding(.top, NeumorphicTheme.Spacing.md)
                }

                Spacer()

                // Keypad
                KeypadView { key in
                    viewModel.handleKeyTap(key)
                }
                .padding(.bottom, NeumorphicTheme.Spacing.lg)
            }
        }
        .sheet(isPresented: $viewModel.showSourcePicker) {
            CurrencyPickerView(
                selectedCurrency: Binding(
                    get: { viewModel.sourceCurrency },
                    set: { viewModel.setSourceCurrency($0) }
                ),
                excludedCurrency: viewModel.targetCurrency
            )
        }
        .sheet(isPresented: $viewModel.showTargetPicker) {
            CurrencyPickerView(
                selectedCurrency: Binding(
                    get: { viewModel.targetCurrency },
                    set: { viewModel.setTargetCurrency($0) }
                ),
                excludedCurrency: viewModel.sourceCurrency
            )
        }
        .sheet(isPresented: $viewModel.showHistory) {
            ConversionHistoryView(
                conversions: viewModel.conversionHistory,
                onClear: { viewModel.clearHistory() },
                onSelect: { viewModel.restoreConversion($0) }
            )
        }
        .onAppear {
            viewModel.performConversion()
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            Text("Convert")
                .font(NeumorphicTheme.Font.titleLarge)
                .foregroundColor(ColorPalette.textPrimary)

            Spacer()

            // History button
            NeumorphicIconButton(icon: "clock.arrow.circlepath", size: 40) {
                viewModel.showHistory = true
            }

            // Save button
            NeumorphicIconButton(icon: "square.and.arrow.down", size: 40) {
                viewModel.saveCurrentConversion()
            }
            .opacity(viewModel.canConvert ? 1 : 0.5)
            .disabled(!viewModel.canConvert)
        }
    }

    private var currencyInputsView: some View {
        VStack(spacing: NeumorphicTheme.Spacing.md) {
            // Source currency
            CurrencyInputView(
                amount: formatDisplayAmount(viewModel.inputAmount),
                currency: viewModel.sourceCurrency,
                isSource: true
            ) {
                viewModel.showSourcePicker = true
            }

            // Swap button
            HStack {
                Spacer()
                SwapButton {
                    viewModel.swapCurrencies()
                }
                Spacer()
            }

            // Target currency
            CurrencyInputView(
                amount: viewModel.convertedAmount,
                currency: viewModel.targetCurrency,
                isSource: false
            ) {
                viewModel.showTargetPicker = true
            }
        }
    }

    private var rateView: some View {
        HStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }

            Text(viewModel.formattedRate)
                .font(NeumorphicTheme.Font.caption)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .padding(.horizontal, NeumorphicTheme.Spacing.md)
        .padding(.vertical, NeumorphicTheme.Spacing.xs)
        .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.small)
    }

    // MARK: - Helpers

    private func formatDisplayAmount(_ amount: String) -> String {
        guard let value = amount.toDouble() else { return amount }
        if amount.hasSuffix(".") {
            return value.formatted(decimals: 0) + "."
        }
        let decimalParts = amount.split(separator: ".")
        if decimalParts.count == 2 {
            let decimalCount = decimalParts[1].count
            return value.formatted(decimals: decimalCount)
        }
        return value.formatted(decimals: 0)
    }
}

#Preview {
    CurrencyConverterView(
        viewModel: CurrencyConverterViewModel(
            repository: CurrencyRepository(
                provider: MockExchangeRateProvider()
            )
        )
    )
}
