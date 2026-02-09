import SwiftUI

/// Main tab navigation for the app
struct MainTabView: View {
    @Environment(\.dependencies) private var dependencies

    @State private var selectedTab: Tab = .convert

    enum Tab: String, CaseIterable {
        case convert
        case crypto

        var title: String {
            switch self {
            case .convert: return "Convert"
            case .crypto: return "Crypto"
            }
        }

        var icon: String {
            switch self {
            case .convert: return "arrow.left.arrow.right.circle"
            case .crypto: return "bitcoinsign.circle"
            }
        }

        var selectedIcon: String {
            switch self {
            case .convert: return "arrow.left.arrow.right.circle.fill"
            case .crypto: return "bitcoinsign.circle.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CurrencyConverterView(
                viewModel: dependencies.makeCurrencyConverterViewModel()
            )
            .tabItem {
                Label(
                    Tab.convert.title,
                    systemImage: selectedTab == .convert ? Tab.convert.selectedIcon : Tab.convert.icon
                )
            }
            .tag(Tab.convert)

            CryptoViewerView(
                viewModel: dependencies.makeCryptoViewerViewModel(),
                repository: dependencies.cryptoRepository
            )
            .tabItem {
                Label(
                    Tab.crypto.title,
                    systemImage: selectedTab == .crypto ? Tab.crypto.selectedIcon : Tab.crypto.icon
                )
            }
            .tag(Tab.crypto)
        }
        .tint(ColorPalette.accentBlue)
        .onAppear {
            configureTabBarAppearance()
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ColorPalette.background)

        // Shadow
        appearance.shadowColor = UIColor(ColorPalette.shadowDark.opacity(0.2))

        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ColorPalette.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ColorPalette.textSecondary)
        ]

        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorPalette.accentBlue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorPalette.accentBlue)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
