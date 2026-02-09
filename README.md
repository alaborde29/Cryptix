# Cryptix

A modern iOS finance application featuring a currency converter and cryptocurrency price viewer with a beautiful neumorphic design.

![iOS 18+](https://img.shields.io/badge/iOS-18%2B-blue)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-purple)

## Features

### Currency Converter
- Real-time currency conversion with live exchange rates
- Calculator-style numeric keypad for easy input
- Support for 24+ world currencies
- Animated swap button to quickly reverse conversion
- Searchable currency picker
- Conversion history with quick restore

### Cryptocurrency Viewer
- Live prices for top 10 cryptocurrencies (BTC, ETH, SOL, XRP, ADA, BNB, DOGE, DOT, AVAX, MATIC)
- Interactive price charts with multiple timeframes (24H, 7D, 30D, 90D, 1Y)
- Touch-to-inspect chart interaction
- 24-hour price change indicators
- Pull-to-refresh and auto-refresh every 5 minutes
- Sorting by price, change percentage, or name

### Design
- Neumorphic UI with soft shadows and depth
- Light mode optimized (#E0E5EC background)
- Smooth animations and haptic feedback
- Rounded system fonts throughout

## Screenshots

| Currency Converter | Crypto List | Price Chart |
|:--:|:--:|:--:|
| Calculator keypad | Live prices | Interactive chart |

## Architecture

The app follows **MVVM + Repository Pattern** with clean separation of concerns:

```
Cryptix/
├── App/                    # App entry point & dependency injection
├── Core/
│   ├── Extensions/         # Color+Hex, Double+Formatting
│   ├── Utilities/          # NetworkMonitor, HapticManager
│   └── Errors/             # NetworkError types
├── DesignSystem/
│   ├── Theme/              # ColorPalette, NeumorphicTheme
│   ├── Components/         # Reusable neumorphic components
│   └── Modifiers/          # Shadow modifiers
├── Data/
│   ├── Networking/         # APIClient, APIEndpoint
│   ├── Providers/          # API implementations
│   ├── Repositories/       # Data access with caching
│   └── Cache/              # UserDefaults-based cache
├── Features/
│   ├── CurrencyConverter/  # Models, ViewModels, Views
│   └── CryptoViewer/       # Models, ViewModels, Views
└── Navigation/             # Tab navigation
```

### Key Technologies
- **SwiftUI** with iOS 18+ features
- **Swift Charts** for price visualization
- **@Observable** macro for reactive ViewModels
- **Async/await** for networking
- **NWPathMonitor** for connectivity status

## APIs

### Exchange Rates
- **Provider:** [ExchangeRate-API](https://www.exchangerate-api.com/)
- **Endpoint:** `https://api.exchangerate-api.com/v4/latest/{base}`
- **Rate Limit:** Free tier, no key required

### Cryptocurrency
- **Provider:** [CoinGecko](https://www.coingecko.com/en/api)
- **Endpoints:**
  - `/coins/markets` - Current prices
  - `/coins/{id}/market_chart` - Historical prices
- **Rate Limit:** Free tier (limited), demo data fallback included

## Caching Strategy

| Data | Duration | Fallback |
|------|----------|----------|
| Exchange Rates | 1 hour | Stale cache |
| Crypto Prices | 5 minutes | Demo data |
| Price History | 5 minutes | Demo data |
| Conversion History | Permanent | - |

## Requirements

- iOS 18.0+
- Xcode 16.0+
- Swift 5.9+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Cryptix.git
```

2. Open the project in Xcode:
```bash
cd Cryptix
open Cryptix.xcodeproj
```

3. Build and run on simulator or device (iPhone recommended)

## Project Structure

### Design System

The neumorphic design system provides consistent styling:

```swift
// Colors
ColorPalette.background      // #E0E5EC
ColorPalette.shadowDark      // #A3B1C6
ColorPalette.shadowLight     // #FFFFFF

// Components
NeumorphicButton(title: "Convert", icon: "arrow.triangle.2.circlepath") { }
NeumorphicCard { Text("Content") }
NeumorphicKeypadButton(label: "1") { }

// Modifiers
.neumorphicShadow(isPressed: false)
.simpleInset(cornerRadius: 12)
```

### Dependency Injection

```swift
@Environment(\.dependencies) private var dependencies

let viewModel = dependencies.makeCurrencyConverterViewModel()
let repository = dependencies.cryptoRepository
```

## Configuration

### Using a CoinGecko API Key (Optional)

To avoid rate limiting, register for a free API key at [CoinGecko](https://www.coingecko.com/en/api/pricing) and add it to the headers in `APIEndpoint.swift`:

```swift
var headers: [String: String] {
    return [
        "Accept": "application/json",
        "x-cg-demo-api-key": "YOUR_API_KEY"
    ]
}
```

## License

This project is available under the MIT License.

## Acknowledgments

- [ExchangeRate-API](https://www.exchangerate-api.com/) for currency exchange rates
- [CoinGecko](https://www.coingecko.com/) for cryptocurrency data
- Neumorphic design inspiration from the soft UI trend
