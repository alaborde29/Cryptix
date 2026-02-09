import SwiftUI

/// Neumorphic color palette optimized for light mode
enum ColorPalette {
    // MARK: - Background Colors
    static let background = Color(hex: "E0E5EC")
    static let backgroundSecondary = Color(hex: "D1D9E6")

    // MARK: - Shadow Colors
    static let shadowDark = Color(hex: "A3B1C6")
    static let shadowLight = Color.white

    // MARK: - Text Colors
    static let textPrimary = Color(hex: "2D3436")
    static let textSecondary = Color(hex: "636E72")
    static let textTertiary = Color(hex: "B2BEC3")

    // MARK: - Accent Colors
    static let accentBlue = Color(hex: "0984E3")
    static let accentGreen = Color(hex: "00B894")
    static let accentRed = Color(hex: "D63031")
    static let accentOrange = Color(hex: "E17055")

    // MARK: - Semantic Colors
    static let positive = accentGreen
    static let negative = accentRed
    static let warning = accentOrange
    static let info = accentBlue

    // MARK: - Gradient
    static let neumorphicGradient = LinearGradient(
        colors: [shadowLight.opacity(0.7), shadowDark.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
