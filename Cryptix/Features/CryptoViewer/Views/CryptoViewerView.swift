import SwiftUI

/// Main cryptocurrency viewer screen
struct CryptoViewerView: View {
    @State private var viewModel: CryptoViewerViewModel
    let repository: CryptoRepository

    init(viewModel: CryptoViewerViewModel, repository: CryptoRepository) {
        _viewModel = State(initialValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.horizontal, NeumorphicTheme.Spacing.md)
                        .padding(.top, NeumorphicTheme.Spacing.sm)

                    // Content
                    if viewModel.isLoading && !viewModel.hasData {
                        loadingView
                    } else if let error = viewModel.error, !viewModel.hasData {
                        errorView(error)
                    } else {
                        cryptoList
                    }
                }
            }
            .task {
                await viewModel.loadPrices()
            }
            .onAppear {
                viewModel.startAutoRefresh()
            }
            .onDisappear {
                viewModel.stopAutoRefresh()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Crypto")
                    .font(NeumorphicTheme.Font.titleLarge)
                    .foregroundColor(ColorPalette.textPrimary)

                if let lastUpdated = viewModel.formattedLastUpdated {
                    Text(lastUpdated)
                        .font(NeumorphicTheme.Font.caption)
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }

            Spacer()

            // Sort menu
            Menu {
                Button("Price (High to Low)") {
                    viewModel.sortByPrice(ascending: false)
                }
                Button("Price (Low to High)") {
                    viewModel.sortByPrice(ascending: true)
                }
                Divider()
                Button("Change (Best)") {
                    viewModel.sortByChange(ascending: false)
                }
                Button("Change (Worst)") {
                    viewModel.sortByChange(ascending: true)
                }
                Divider()
                Button("Name") {
                    viewModel.sortByName()
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorPalette.textPrimary)
                    .frame(width: 40, height: 40)
                    .neumorphicCircleShadow()
            }

            // Refresh button
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                Group {
                    if viewModel.isRefreshing {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .foregroundColor(ColorPalette.textPrimary)
                .frame(width: 40, height: 40)
                .neumorphicCircleShadow()
            }
            .disabled(viewModel.isRefreshing)
        }
    }

    private var loadingView: some View {
        VStack(spacing: NeumorphicTheme.Spacing.md) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading prices...")
                .font(NeumorphicTheme.Font.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
            Spacer()
        }
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: NeumorphicTheme.Spacing.md) {
            Spacer()

            Image(systemName: "wifi.slash")
                .font(.system(size: 48))
                .foregroundColor(ColorPalette.textTertiary)

            Text("Unable to load prices")
                .font(NeumorphicTheme.Font.titleMedium)
                .foregroundColor(ColorPalette.textSecondary)

            Text(error)
                .font(NeumorphicTheme.Font.bodyMedium)
                .foregroundColor(ColorPalette.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            NeumorphicButton(title: "Try Again", icon: "arrow.clockwise") {
                Task {
                    await viewModel.loadPrices()
                }
            }

            Spacer()
        }
    }

    private var cryptoList: some View {
        ScrollView {
            LazyVStack(spacing: NeumorphicTheme.Spacing.sm) {
                ForEach(viewModel.cryptocurrencies) { crypto in
                    NavigationLink(destination: CryptoDetailView(crypto: crypto, repository: repository)) {
                        CryptoCardView(crypto: crypto)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, NeumorphicTheme.Spacing.md)
            .padding(.top, NeumorphicTheme.Spacing.md)
            .padding(.bottom, NeumorphicTheme.Spacing.xxl)
        }
    }
}

#Preview {
    let repository = CryptoRepository(provider: MockCryptoProvider())
    CryptoViewerView(
        viewModel: CryptoViewerViewModel(repository: repository),
        repository: repository
    )
}
