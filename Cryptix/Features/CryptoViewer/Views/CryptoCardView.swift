import SwiftUI

/// Neumorphic card displaying cryptocurrency info
struct CryptoCardView: View {
    let crypto: Cryptocurrency

    @State private var isPressed = false

    var body: some View {
        HStack(spacing: NeumorphicTheme.Spacing.md) {
            // Crypto icon
            AsyncImage(url: URL(string: crypto.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 44, height: 44)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                case .failure:
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(ColorPalette.textTertiary)
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(Circle())

            // Name and symbol
            VStack(alignment: .leading, spacing: 2) {
                Text(crypto.name)
                    .font(NeumorphicTheme.Font.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorPalette.textPrimary)
                    .lineLimit(1)

                Text(crypto.symbolUppercased)
                    .font(NeumorphicTheme.Font.caption)
                    .foregroundColor(ColorPalette.textSecondary)
            }

            Spacer()

            // Price and change
            VStack(alignment: .trailing, spacing: 4) {
                Text(crypto.formattedPriceWithSymbol)
                    .font(NeumorphicTheme.Font.bodyLarge)
                    .fontWeight(.bold)
                    .foregroundColor(ColorPalette.textPrimary)

                PriceChangeIndicator(change: crypto.priceChangePercentage24h)
            }
        }
        .padding(NeumorphicTheme.Spacing.md)
        .neumorphicShadow(isPressed: isPressed, cornerRadius: NeumorphicTheme.CornerRadius.large)
    }
}

/// Compact version for smaller displays
struct CompactCryptoCardView: View {
    let crypto: Cryptocurrency

    var body: some View {
        VStack(spacing: NeumorphicTheme.Spacing.sm) {
            // Icon
            AsyncImage(url: URL(string: crypto.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                default:
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
            .clipShape(Circle())

            // Symbol
            Text(crypto.symbolUppercased)
                .font(NeumorphicTheme.Font.caption)
                .fontWeight(.semibold)
                .foregroundColor(ColorPalette.textPrimary)

            // Price
            Text(crypto.formattedPriceWithSymbol)
                .font(NeumorphicTheme.Font.caption)
                .foregroundColor(ColorPalette.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            // Change indicator
            PriceChangeIndicator(change: crypto.priceChangePercentage24h)
        }
        .padding(NeumorphicTheme.Spacing.sm)
        .frame(width: 100)
        .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.medium)
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack(spacing: 20) {
            CryptoCardView(crypto: .preview)
                .padding(.horizontal)

            HStack(spacing: 16) {
                ForEach(Cryptocurrency.previewList) { crypto in
                    CompactCryptoCardView(crypto: crypto)
                }
            }
        }
    }
}
