import SwiftUI

/// Recent conversions sheet
struct ConversionHistoryView: View {
    @Environment(\.dismiss) private var dismiss

    let conversions: [ConversionResult]
    let onClear: () -> Void
    let onSelect: (ConversionResult) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.background.ignoresSafeArea()

                if conversions.isEmpty {
                    emptyStateView
                } else {
                    historyList
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !conversions.isEmpty {
                        Button("Clear") {
                            HapticManager.warning()
                            onClear()
                        }
                        .foregroundColor(ColorPalette.negative)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorPalette.accentBlue)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: NeumorphicTheme.Spacing.md) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundColor(ColorPalette.textTertiary)

            Text("No conversions yet")
                .font(NeumorphicTheme.Font.titleMedium)
                .foregroundColor(ColorPalette.textSecondary)

            Text("Your conversion history will appear here")
                .font(NeumorphicTheme.Font.bodyMedium)
                .foregroundColor(ColorPalette.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var historyList: some View {
        ScrollView {
            LazyVStack(spacing: NeumorphicTheme.Spacing.sm) {
                ForEach(conversions) { conversion in
                    ConversionHistoryRow(conversion: conversion) {
                        onSelect(conversion)
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, NeumorphicTheme.Spacing.md)
            .padding(.top, NeumorphicTheme.Spacing.sm)
        }
    }
}

/// Individual conversion history row
private struct ConversionHistoryRow: View {
    let conversion: ConversionResult
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticManager.selectionChanged()
            action()
        }) {
            VStack(alignment: .leading, spacing: NeumorphicTheme.Spacing.xs) {
                // Conversion display
                HStack {
                    // From
                    VStack(alignment: .leading, spacing: 2) {
                        Text(conversion.fromCurrency)
                            .font(NeumorphicTheme.Font.caption)
                            .foregroundColor(ColorPalette.textTertiary)

                        Text(conversion.formattedFromAmount)
                            .font(NeumorphicTheme.Font.titleMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorPalette.textPrimary)
                    }

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorPalette.textTertiary)

                    Spacer()

                    // To
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(conversion.toCurrency)
                            .font(NeumorphicTheme.Font.caption)
                            .foregroundColor(ColorPalette.textTertiary)

                        Text(conversion.formattedToAmount)
                            .font(NeumorphicTheme.Font.titleMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorPalette.accentBlue)
                    }
                }

                // Timestamp and rate
                HStack {
                    Text(conversion.formattedTimestamp)
                        .font(NeumorphicTheme.Font.caption)
                        .foregroundColor(ColorPalette.textTertiary)

                    Spacer()

                    Text(conversion.formattedRate)
                        .font(NeumorphicTheme.Font.caption)
                        .foregroundColor(ColorPalette.textSecondary)
                }
            }
            .padding(NeumorphicTheme.Spacing.md)
            .neumorphicShadow(isPressed: isPressed, cornerRadius: NeumorphicTheme.CornerRadius.medium)
        }
        .buttonStyle(HistoryRowButtonStyle(isPressed: $isPressed))
    }
}

private struct HistoryRowButtonStyle: ButtonStyle {
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
    ConversionHistoryView(
        conversions: [
            ConversionResult(
                fromCurrency: "USD",
                toCurrency: "EUR",
                fromAmount: 100,
                toAmount: 92.50,
                rate: 0.925
            ),
            ConversionResult(
                fromCurrency: "GBP",
                toCurrency: "JPY",
                fromAmount: 500,
                toAmount: 94250,
                rate: 188.5
            )
        ],
        onClear: {},
        onSelect: { _ in }
    )
}
