import SwiftUI

/// A circular neumorphic button for calculator keypads
struct NeumorphicKeypadButton: View {
    let label: String
    let systemImage: String?
    let diameter: CGFloat
    let isAccent: Bool
    let action: () -> Void

    @State private var isPressed = false

    init(
        label: String,
        systemImage: String? = nil,
        diameter: CGFloat = NeumorphicTheme.ButtonSize.keypadDiameter,
        isAccent: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.diameter = diameter
        self.isAccent = isAccent
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle()
                    .fill(isAccent ? ColorPalette.accentBlue : ColorPalette.background)

                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: diameter * 0.35, weight: .medium))
                        .foregroundColor(isAccent ? .white : ColorPalette.textPrimary)
                } else {
                    Text(label)
                        .font(NeumorphicTheme.Font.keypad)
                        .foregroundColor(isAccent ? .white : ColorPalette.textPrimary)
                }
            }
            .frame(width: diameter, height: diameter)
            .background(
                Circle()
                    .fill(isAccent ? ColorPalette.accentBlue : ColorPalette.background)
                    .shadow(
                        color: isPressed ? ColorPalette.shadowDark.opacity(0.2) : ColorPalette.shadowLight,
                        radius: isPressed ? NeumorphicTheme.Shadow.radiusSmall : NeumorphicTheme.Shadow.radius,
                        x: isPressed ? 2 : NeumorphicTheme.Shadow.offsetLight,
                        y: isPressed ? 2 : NeumorphicTheme.Shadow.offsetLight
                    )
                    .shadow(
                        color: isPressed ? ColorPalette.shadowLight.opacity(0.5) : ColorPalette.shadowDark.opacity(0.4),
                        radius: isPressed ? NeumorphicTheme.Shadow.radiusSmall : NeumorphicTheme.Shadow.radius,
                        x: isPressed ? -2 : NeumorphicTheme.Shadow.offsetDark,
                        y: isPressed ? -2 : NeumorphicTheme.Shadow.offsetDark
                    )
            )
        }
        .buttonStyle(KeypadButtonStyle(isPressed: $isPressed))
    }
}

/// Button style for keypad buttons
private struct KeypadButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(NeumorphicTheme.Animation.quick, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                NeumorphicKeypadButton(label: "1") {}
                NeumorphicKeypadButton(label: "2") {}
                NeumorphicKeypadButton(label: "3") {}
            }
            HStack(spacing: 20) {
                NeumorphicKeypadButton(label: "4") {}
                NeumorphicKeypadButton(label: "5") {}
                NeumorphicKeypadButton(label: "6") {}
            }
            HStack(spacing: 20) {
                NeumorphicKeypadButton(label: "", systemImage: "delete.left") {}
                NeumorphicKeypadButton(label: "0") {}
                NeumorphicKeypadButton(label: ".", isAccent: true) {}
            }
        }
    }
}
