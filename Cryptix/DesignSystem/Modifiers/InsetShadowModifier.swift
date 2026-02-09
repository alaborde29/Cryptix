import SwiftUI

/// Modifier that applies neumorphic inset/pressed shadow effect
struct InsetShadowModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ColorPalette.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(ColorPalette.shadowDark.opacity(0.3), lineWidth: 1)
                            .blur(radius: 2)
                            .offset(x: 2, y: 2)
                            .mask(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .fill(LinearGradient(
                                        colors: [.black, .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(ColorPalette.shadowLight, lineWidth: 1)
                            .blur(radius: 2)
                            .offset(x: -2, y: -2)
                            .mask(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .fill(LinearGradient(
                                        colors: [.clear, .black],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .inset(by: 0.5)
                    .stroke(
                        LinearGradient(
                            colors: [
                                ColorPalette.shadowDark.opacity(0.2),
                                ColorPalette.shadowLight.opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

/// Simplified inset shadow for input fields
struct SimpleInsetModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ColorPalette.backgroundSecondary.opacity(0.5))
                    .shadow(
                        color: ColorPalette.shadowDark.opacity(0.25),
                        radius: 3,
                        x: 2,
                        y: 2
                    )
                    .shadow(
                        color: ColorPalette.shadowLight.opacity(0.8),
                        radius: 3,
                        x: -2,
                        y: -2
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
    }
}

extension View {
    func insetShadow(cornerRadius: CGFloat = NeumorphicTheme.CornerRadius.medium) -> some View {
        modifier(InsetShadowModifier(cornerRadius: cornerRadius))
    }

    func simpleInset(cornerRadius: CGFloat = NeumorphicTheme.CornerRadius.medium) -> some View {
        modifier(SimpleInsetModifier(cornerRadius: cornerRadius))
    }
}
