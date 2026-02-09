import SwiftUI

/// Detail view for a cryptocurrency with price chart
struct CryptoDetailView: View {
    let crypto: Cryptocurrency
    let repository: CryptoRepository

    @State private var pricePoints: [PricePoint] = []
    @State private var selectedRange: PriceHistoryRange = .week
    @State private var isLoading = false
    @State private var error: String?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            ColorPalette.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: NeumorphicTheme.Spacing.lg) {
                    // Header
                    headerView

                    // Price info
                    priceInfoView

                    // Chart section
                    chartSection

                    // Stats
                    statsSection
                }
                .padding(.horizontal, NeumorphicTheme.Spacing.md)
                .padding(.top, NeumorphicTheme.Spacing.md)
                .padding(.bottom, NeumorphicTheme.Spacing.xxl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(crypto.name)
                    .font(NeumorphicTheme.Font.titleMedium)
                    .foregroundColor(ColorPalette.textPrimary)
            }
        }
        .task {
            await loadPriceHistory()
        }
        .onChange(of: selectedRange) { _, _ in
            Task {
                await loadPriceHistory()
            }
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack(spacing: NeumorphicTheme.Spacing.md) {
            // Icon
            AsyncImage(url: URL(string: crypto.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                default:
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(crypto.name)
                    .font(NeumorphicTheme.Font.titleLarge)
                    .fontWeight(.bold)
                    .foregroundColor(ColorPalette.textPrimary)

                Text(crypto.symbolUppercased)
                    .font(NeumorphicTheme.Font.bodyMedium)
                    .foregroundColor(ColorPalette.textSecondary)
            }

            Spacer()
        }
        .padding(NeumorphicTheme.Spacing.md)
        .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.large)
    }

    private var priceInfoView: some View {
        VStack(spacing: NeumorphicTheme.Spacing.sm) {
            Text(crypto.formattedPriceWithSymbol)
                .font(NeumorphicTheme.Font.displayLarge)
                .fontWeight(.bold)
                .foregroundColor(ColorPalette.textPrimary)

            LargePriceChangeIndicator(change: crypto.priceChangePercentage24h)
        }
        .frame(maxWidth: .infinity)
        .padding(NeumorphicTheme.Spacing.lg)
        .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.large)
    }

    private var chartSection: some View {
        VStack(spacing: NeumorphicTheme.Spacing.md) {
            // Range selector
            ChartRangeSelector(selectedRange: $selectedRange)

            // Chart
            if isLoading && pricePoints.isEmpty {
                loadingView
            } else if let error = error, pricePoints.isEmpty {
                errorView(error)
            } else {
                PriceChartView(
                    pricePoints: pricePoints,
                    isPositive: crypto.isPositiveChange
                )
                .overlay(alignment: .topTrailing) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.7)
                            .padding(8)
                    }
                }
            }
        }
        .padding(NeumorphicTheme.Spacing.md)
        .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.large)
    }

    private var statsSection: some View {
        VStack(spacing: NeumorphicTheme.Spacing.sm) {
            Text("Statistics")
                .font(NeumorphicTheme.Font.titleMedium)
                .fontWeight(.semibold)
                .foregroundColor(ColorPalette.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            StatRow(label: "Current Price", value: crypto.formattedPriceWithSymbol)
            StatRow(label: "24h Change", value: crypto.formattedChange, valueColor: crypto.isPositiveChange ? ColorPalette.positive : ColorPalette.negative)

            if !pricePoints.isEmpty {
                let high = pricePoints.map(\.price).max() ?? 0
                let low = pricePoints.map(\.price).min() ?? 0

                StatRow(label: "\(selectedRange.rawValue) High", value: "$\(high.asCryptoPrice())")
                StatRow(label: "\(selectedRange.rawValue) Low", value: "$\(low.asCryptoPrice())")
            }
        }
        .padding(NeumorphicTheme.Spacing.md)
        .neumorphicShadow(cornerRadius: NeumorphicTheme.CornerRadius.large)
    }

    private var loadingView: some View {
        VStack(spacing: NeumorphicTheme.Spacing.md) {
            ProgressView()
            Text("Loading chart...")
                .font(NeumorphicTheme.Font.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: NeumorphicTheme.Spacing.sm) {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.system(size: 32))
                .foregroundColor(ColorPalette.textTertiary)

            Text("Unable to load chart")
                .font(NeumorphicTheme.Font.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)

            Button("Retry") {
                Task {
                    await loadPriceHistory()
                }
            }
            .font(NeumorphicTheme.Font.caption)
            .foregroundColor(ColorPalette.accentBlue)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Data Loading

    private func loadPriceHistory() async {
        isLoading = true
        error = nil

        do {
            pricePoints = try await repository.getPriceHistory(
                id: crypto.id,
                range: selectedRange
            )
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}

/// Row for displaying a stat
private struct StatRow: View {
    let label: String
    let value: String
    var valueColor: Color = ColorPalette.textPrimary

    var body: some View {
        HStack {
            Text(label)
                .font(NeumorphicTheme.Font.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)

            Spacer()

            Text(value)
                .font(NeumorphicTheme.Font.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(valueColor)
        }
        .padding(.vertical, NeumorphicTheme.Spacing.xs)
    }
}

#Preview {
    NavigationStack {
        CryptoDetailView(
            crypto: .preview,
            repository: CryptoRepository(provider: MockCryptoProvider())
        )
    }
}
