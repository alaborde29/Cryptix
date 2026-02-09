import SwiftUI

/// Amount display with currency selector
struct CurrencyInputView: View {
    let amount: String
    let currency: Currency
    let isSource: Bool
    let onCurrencyTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: NeumorphicTheme.Spacing.xs) {
            // Label
            Text(isSource ? "From" : "To")
                .font(NeumorphicTheme.Font.caption)
                .foregroundColor(ColorPalette.textTertiary)
                .padding(.leading, NeumorphicTheme.Spacing.xs)

            // Input container
            HStack(spacing: NeumorphicTheme.Spacing.md) {
                // Currency selector
                Button(action: {
                    HapticManager.selectionChanged()
                    onCurrencyTap()
                }) {
                    HStack(spacing: NeumorphicTheme.Spacing.xs) {
                        Text(currency.flag)
                            .font(.system(size: 28))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(currency.code)
                                .font(NeumorphicTheme.Font.bodyLarge)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorPalette.textPrimary)

                            Text(currency.name)
                                .font(NeumorphicTheme.Font.caption)
                                .foregroundColor(ColorPalette.textSecondary)
                                .lineLimit(1)
                        }

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorPalette.textTertiary)
                    }
                    .padding(NeumorphicTheme.Spacing.sm)
                    .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.medium)
                }
                .buttonStyle(.plain)

                Spacer()

                // Amount display
                VStack(alignment: .trailing, spacing: 2) {
                    Text(displayAmount)
                        .font(isSource ? NeumorphicTheme.Font.displayMedium : NeumorphicTheme.Font.titleLarge)
                        .fontWeight(.bold)
                        .foregroundColor(isSource ? ColorPalette.textPrimary : ColorPalette.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    if !isSource {
                        Text(currency.symbol)
                            .font(NeumorphicTheme.Font.caption)
                            .foregroundColor(ColorPalette.textTertiary)
                    }
                }
            }
            .padding(NeumorphicTheme.Spacing.md)
            .simpleInset(cornerRadius: NeumorphicTheme.CornerRadius.large)
        }
    }

    private var displayAmount: String {
        if amount.isEmpty || amount == "0" {
            return "0"
        }
        return amount
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack(spacing: 20) {
            CurrencyInputView(
                amount: "1,234.56",
                currency: .usd,
                isSource: true
            ) {
                print("Currency tapped")
            }
            .padding(.horizontal)

            CurrencyInputView(
                amount: "1,142.35",
                currency: .eur,
                isSource: false
            ) {
                print("Currency tapped")
            }
            .padding(.horizontal)
        }
    }
}
