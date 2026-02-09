import SwiftUI

/// Green/red percentage indicator with arrow
struct PriceChangeIndicator: View {
    let change: Double

    private var isPositive: Bool {
        change >= 0
    }

    private var color: Color {
        isPositive ? ColorPalette.positive : ColorPalette.negative
    }

    private var arrowIcon: String {
        isPositive ? "arrow.up.right" : "arrow.down.right"
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: arrowIcon)
                .font(.system(size: 10, weight: .bold))

            Text(change.asPercentage(decimals: 2, includeSign: false))
                .font(NeumorphicTheme.Font.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(color)
        .padding(.horizontal, NeumorphicTheme.Spacing.xs)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: NeumorphicTheme.CornerRadius.small)
                .fill(color.opacity(0.15))
        )
    }
}

/// Larger price change indicator for detail views
struct LargePriceChangeIndicator: View {
    let change: Double

    private var isPositive: Bool {
        change >= 0
    }

    private var color: Color {
        isPositive ? ColorPalette.positive : ColorPalette.negative
    }

    private var arrowIcon: String {
        isPositive ? "arrow.up.right" : "arrow.down.right"
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: arrowIcon)
                .font(.system(size: 14, weight: .bold))

            Text(change.asPercentage(decimals: 2, includeSign: false))
                .font(NeumorphicTheme.Font.bodyMedium)
                .fontWeight(.semibold)

            Text("24h")
                .font(NeumorphicTheme.Font.caption)
                .foregroundColor(color.opacity(0.8))
        }
        .foregroundColor(color)
        .padding(.horizontal, NeumorphicTheme.Spacing.sm)
        .padding(.vertical, NeumorphicTheme.Spacing.xs)
        .background(
            RoundedRectangle(cornerRadius: NeumorphicTheme.CornerRadius.medium)
                .fill(color.opacity(0.15))
        )
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack(spacing: 20) {
            PriceChangeIndicator(change: 5.25)
            PriceChangeIndicator(change: -2.35)
            LargePriceChangeIndicator(change: 5.25)
            LargePriceChangeIndicator(change: -2.35)
        }
    }
}
