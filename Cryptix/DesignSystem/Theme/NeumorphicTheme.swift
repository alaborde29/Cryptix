import SwiftUI

/// Theme constants for neumorphic design
enum NeumorphicTheme {
    // MARK: - Spacing
    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 20
        static let circular: CGFloat = 9999
    }

    // MARK: - Shadow
    enum Shadow {
        static let offsetLight: CGFloat = -6
        static let offsetDark: CGFloat = 6
        static let radius: CGFloat = 10
        static let offsetLightSmall: CGFloat = -3
        static let offsetDarkSmall: CGFloat = 3
        static let radiusSmall: CGFloat = 5
    }

    // MARK: - Button Sizes
    enum ButtonSize {
        static let keypadDiameter: CGFloat = 70
        static let keypadSpacing: CGFloat = 16
        static let iconButton: CGFloat = 44
        static let swapButton: CGFloat = 56
    }

    // MARK: - Animation
    enum Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.15)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.25)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.6)
    }

    // MARK: - Font
    enum Font {
        static let displayLarge = SwiftUI.Font.system(size: 48, weight: .bold, design: .rounded)
        static let displayMedium = SwiftUI.Font.system(size: 36, weight: .bold, design: .rounded)
        static let titleLarge = SwiftUI.Font.system(size: 24, weight: .semibold, design: .rounded)
        static let titleMedium = SwiftUI.Font.system(size: 20, weight: .semibold, design: .rounded)
        static let bodyLarge = SwiftUI.Font.system(size: 17, weight: .regular, design: .rounded)
        static let bodyMedium = SwiftUI.Font.system(size: 15, weight: .regular, design: .rounded)
        static let caption = SwiftUI.Font.system(size: 13, weight: .medium, design: .rounded)
        static let keypad = SwiftUI.Font.system(size: 28, weight: .medium, design: .rounded)
    }
}
