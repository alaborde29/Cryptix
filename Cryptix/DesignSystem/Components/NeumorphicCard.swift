import SwiftUI

/// A neumorphic styled card container
struct NeumorphicCard<Content: View>: View {
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content

    init(
        cornerRadius: CGFloat = NeumorphicTheme.CornerRadius.large,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        content()
            .padding(NeumorphicTheme.Spacing.md)
            .neumorphicShadow(isPressed: false, cornerRadius: cornerRadius)
    }
}

/// A flat neumorphic card with subtle shadow
struct NeumorphicFlatCard<Content: View>: View {
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content

    init(
        cornerRadius: CGFloat = NeumorphicTheme.CornerRadius.large,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        content()
            .padding(NeumorphicTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ColorPalette.background)
                    .shadow(
                        color: ColorPalette.shadowDark.opacity(0.15),
                        radius: 8,
                        x: 4,
                        y: 4
                    )
                    .shadow(
                        color: ColorPalette.shadowLight.opacity(0.7),
                        radius: 8,
                        x: -4,
                        y: -4
                    )
            )
    }
}

/// An inset neumorphic card for input areas
struct NeumorphicInsetCard<Content: View>: View {
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content

    init(
        cornerRadius: CGFloat = NeumorphicTheme.CornerRadius.large,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        content()
            .padding(NeumorphicTheme.Spacing.md)
            .simpleInset(cornerRadius: cornerRadius)
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack(spacing: 24) {
            NeumorphicCard {
                Text("Extruded Card")
                    .font(NeumorphicTheme.Font.titleMedium)
                    .foregroundColor(ColorPalette.textPrimary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)

            NeumorphicFlatCard {
                Text("Flat Card")
                    .font(NeumorphicTheme.Font.titleMedium)
                    .foregroundColor(ColorPalette.textPrimary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)

            NeumorphicInsetCard {
                Text("Inset Card")
                    .font(NeumorphicTheme.Font.titleMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
    }
}
