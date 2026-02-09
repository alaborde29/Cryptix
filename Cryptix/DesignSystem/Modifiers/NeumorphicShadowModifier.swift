import SwiftUI

/// Modifier that applies neumorphic extruded shadow effect
struct NeumorphicShadowModifier: ViewModifier {
    let isPressed: Bool
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ColorPalette.background)
                    .shadow(
                        color: isPressed ? ColorPalette.shadowDark.opacity(0.3) : ColorPalette.shadowLight,
                        radius: isPressed ? NeumorphicTheme.Shadow.radiusSmall : NeumorphicTheme.Shadow.radius,
                        x: isPressed ? NeumorphicTheme.Shadow.offsetDarkSmall : NeumorphicTheme.Shadow.offsetLight,
                        y: isPressed ? NeumorphicTheme.Shadow.offsetDarkSmall : NeumorphicTheme.Shadow.offsetLight
                    )
                    .shadow(
                        color: isPressed ? ColorPalette.shadowLight.opacity(0.7) : ColorPalette.shadowDark.opacity(0.5),
                        radius: isPressed ? NeumorphicTheme.Shadow.radiusSmall : NeumorphicTheme.Shadow.radius,
                        x: isPressed ? NeumorphicTheme.Shadow.offsetLightSmall : NeumorphicTheme.Shadow.offsetDark,
                        y: isPressed ? NeumorphicTheme.Shadow.offsetLightSmall : NeumorphicTheme.Shadow.offsetDark
                    )
            )
    }
}

/// Modifier for circular neumorphic elements
struct NeumorphicCircleShadowModifier: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .fill(ColorPalette.background)
                    .shadow(
                        color: isPressed ? ColorPalette.shadowDark.opacity(0.3) : ColorPalette.shadowLight,
                        radius: isPressed ? NeumorphicTheme.Shadow.radiusSmall : NeumorphicTheme.Shadow.radius,
                        x: isPressed ? NeumorphicTheme.Shadow.offsetDarkSmall : NeumorphicTheme.Shadow.offsetLight,
                        y: isPressed ? NeumorphicTheme.Shadow.offsetDarkSmall : NeumorphicTheme.Shadow.offsetLight
                    )
                    .shadow(
                        color: isPressed ? ColorPalette.shadowLight.opacity(0.7) : ColorPalette.shadowDark.opacity(0.5),
                        radius: isPressed ? NeumorphicTheme.Shadow.radiusSmall : NeumorphicTheme.Shadow.radius,
                        x: isPressed ? NeumorphicTheme.Shadow.offsetLightSmall : NeumorphicTheme.Shadow.offsetDark,
                        y: isPressed ? NeumorphicTheme.Shadow.offsetLightSmall : NeumorphicTheme.Shadow.offsetDark
                    )
            )
    }
}

extension View {
    func neumorphicShadow(isPressed: Bool = false, cornerRadius: CGFloat = NeumorphicTheme.CornerRadius.medium) -> some View {
        modifier(NeumorphicShadowModifier(isPressed: isPressed, cornerRadius: cornerRadius))
    }

    func neumorphicCircleShadow(isPressed: Bool = false) -> some View {
        modifier(NeumorphicCircleShadowModifier(isPressed: isPressed))
    }
}
