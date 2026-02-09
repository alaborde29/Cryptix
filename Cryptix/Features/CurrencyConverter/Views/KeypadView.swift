import SwiftUI

/// Calculator-style numeric keypad (3x4 grid)
struct KeypadView: View {
    let onKeyTap: (KeypadKey) -> Void

    private let keys: [[KeypadKey]] = [
        [.digit("1"), .digit("2"), .digit("3")],
        [.digit("4"), .digit("5"), .digit("6")],
        [.digit("7"), .digit("8"), .digit("9")],
        [.decimal, .digit("0"), .delete]
    ]

    var body: some View {
        VStack(spacing: NeumorphicTheme.ButtonSize.keypadSpacing) {
            ForEach(keys.indices, id: \.self) { rowIndex in
                HStack(spacing: NeumorphicTheme.ButtonSize.keypadSpacing) {
                    ForEach(keys[rowIndex], id: \.self) { key in
                        KeypadButtonView(key: key) {
                            HapticManager.lightImpact()
                            onKeyTap(key)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, NeumorphicTheme.Spacing.md)
    }
}

/// Individual keypad button
private struct KeypadButtonView: View {
    let key: KeypadKey
    let action: () -> Void

    var body: some View {
        NeumorphicKeypadButton(
            label: key.label,
            systemImage: key.systemImage,
            diameter: NeumorphicTheme.ButtonSize.keypadDiameter,
            isAccent: key.isAccent,
            action: action
        )
    }
}

/// Keypad key types
enum KeypadKey: Hashable {
    case digit(String)
    case decimal
    case delete

    var label: String {
        switch self {
        case .digit(let value):
            return value
        case .decimal:
            return "."
        case .delete:
            return ""
        }
    }

    var systemImage: String? {
        switch self {
        case .delete:
            return "delete.left"
        default:
            return nil
        }
    }

    var isAccent: Bool {
        return false
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        KeypadView { key in
            print("Tapped: \(key)")
        }
    }
}
