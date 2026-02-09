import SwiftUI

/// A neumorphic styled button
struct NeumorphicButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    @State private var isPressed = false

    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: NeumorphicTheme.Spacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(NeumorphicTheme.Font.bodyLarge)
                    .fontWeight(.semibold)
            }
            .foregroundColor(ColorPalette.textPrimary)
            .padding(.horizontal, NeumorphicTheme.Spacing.lg)
            .padding(.vertical, NeumorphicTheme.Spacing.md)
            .neumorphicShadow(isPressed: isPressed, cornerRadius: NeumorphicTheme.CornerRadius.medium)
        }
        .buttonStyle(NeumorphicButtonStyle(isPressed: $isPressed))
    }
}

/// Icon-only neumorphic button
struct NeumorphicIconButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void

    @State private var isPressed = false

    init(icon: String, size: CGFloat = NeumorphicTheme.ButtonSize.iconButton, action: @escaping () -> Void) {
        self.icon = icon
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundColor(ColorPalette.textPrimary)
                .frame(width: size, height: size)
                .neumorphicCircleShadow(isPressed: isPressed)
        }
        .buttonStyle(NeumorphicButtonStyle(isPressed: $isPressed))
    }
}

/// Button style that tracks press state
struct NeumorphicButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(NeumorphicTheme.Animation.quick, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack(spacing: 24) {
            NeumorphicButton(title: "Convert", icon: "arrow.triangle.2.circlepath") {
                print("Tapped")
            }
            NeumorphicIconButton(icon: "arrow.up.arrow.down") {
                print("Icon tapped")
            }
        }
    }
}
