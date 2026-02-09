import SwiftUI

/// Searchable currency list sheet
struct CurrencyPickerView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedCurrency: Currency
    let excludedCurrency: Currency?

    @State private var searchText = ""

    private var filteredCurrencies: [Currency] {
        let currencies = Currency.all.filter { $0.code != excludedCurrency?.code }

        if searchText.isEmpty {
            return currencies
        }

        return currencies.filter { currency in
            currency.code.localizedCaseInsensitiveContains(searchText) ||
            currency.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.background.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: NeumorphicTheme.Spacing.sm) {
                        ForEach(filteredCurrencies) { currency in
                            CurrencyRowView(
                                currency: currency,
                                isSelected: currency.code == selectedCurrency.code
                            ) {
                                HapticManager.selectionChanged()
                                selectedCurrency = currency
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, NeumorphicTheme.Spacing.md)
                    .padding(.top, NeumorphicTheme.Spacing.sm)
                }
            }
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorPalette.accentBlue)
                }
            }
            .searchable(text: $searchText, prompt: "Search currencies")
        }
    }
}

/// Individual currency row
private struct CurrencyRowView: View {
    let currency: Currency
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: NeumorphicTheme.Spacing.md) {
                Text(currency.flag)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 2) {
                    Text(currency.code)
                        .font(NeumorphicTheme.Font.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorPalette.textPrimary)

                    Text(currency.name)
                        .font(NeumorphicTheme.Font.bodyMedium)
                        .foregroundColor(ColorPalette.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(ColorPalette.accentBlue)
                }
            }
            .padding(NeumorphicTheme.Spacing.md)
            .neumorphicShadow(isPressed: isPressed, cornerRadius: NeumorphicTheme.CornerRadius.medium)
        }
        .buttonStyle(CurrencyRowButtonStyle(isPressed: $isPressed))
    }
}

private struct CurrencyRowButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(NeumorphicTheme.Animation.quick, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    CurrencyPickerView(
        selectedCurrency: .constant(.usd),
        excludedCurrency: .eur
    )
}
