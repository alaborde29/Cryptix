import SwiftUI

/// Animated currency swap button with 180-degree rotation
struct SwapButton: View {
    let action: () -> Void

    @State private var rotation: Double = 0
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticManager.mediumImpact()
            withAnimation(NeumorphicTheme.Animation.spring) {
                rotation += 180
            }
            action()
        }) {
            ZStack {
                Circle()
                    .fill(ColorPalette.accentBlue)
                    .frame(width: NeumorphicTheme.ButtonSize.swapButton, height: NeumorphicTheme.ButtonSize.swapButton)

                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotation))
            }
            .background(
                Circle()
                    .fill(ColorPalette.accentBlue)
                    .shadow(
                        color: isPressed ? ColorPalette.shadowDark.opacity(0.2) : ColorPalette.shadowLight,
                        radius: isPressed ? 3 : 8,
                        x: isPressed ? 2 : -4,
                        y: isPressed ? 2 : -4
                    )
                    .shadow(
                        color: isPressed ? ColorPalette.shadowLight.opacity(0.5) : ColorPalette.accentBlue.opacity(0.4),
                        radius: isPressed ? 3 : 8,
                        x: isPressed ? -2 : 4,
                        y: isPressed ? -2 : 4
                    )
            )
        }
        .buttonStyle(SwapButtonStyle(isPressed: $isPressed))
    }
}

private struct SwapButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(NeumorphicTheme.Animation.quick, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        SwapButton {
            print("Swapped")
        }
    }
}
