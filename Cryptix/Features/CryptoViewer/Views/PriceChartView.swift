import SwiftUI
import Charts

/// Interactive price chart for cryptocurrency
struct PriceChartView: View {
    let pricePoints: [PricePoint]
    let isPositive: Bool

    @State private var selectedPoint: PricePoint?

    private var chartColor: Color {
        isPositive ? ColorPalette.positive : ColorPalette.negative
    }

    private var minPrice: Double {
        pricePoints.map(\.price).min() ?? 0
    }

    private var maxPrice: Double {
        pricePoints.map(\.price).max() ?? 0
    }

    private var priceRange: ClosedRange<Double> {
        let padding = (maxPrice - minPrice) * 0.1
        return (minPrice - padding)...(maxPrice + padding)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: NeumorphicTheme.Spacing.sm) {
            // Selected point info
            if let point = selectedPoint {
                selectedPointView(point)
            }

            // Chart
            Chart {
                ForEach(pricePoints) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Price", point.price)
                    )
                    .foregroundStyle(chartColor)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Date", point.date),
                        yStart: .value("Min", minPrice - (maxPrice - minPrice) * 0.1),
                        yEnd: .value("Price", point.price)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [chartColor.opacity(0.3), chartColor.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }

                if let selected = selectedPoint {
                    RuleMark(x: .value("Selected", selected.date))
                        .foregroundStyle(ColorPalette.textTertiary.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))

                    PointMark(
                        x: .value("Date", selected.date),
                        y: .value("Price", selected.price)
                    )
                    .foregroundStyle(chartColor)
                    .symbolSize(100)
                }
            }
            .chartYScale(domain: priceRange)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(ColorPalette.shadowDark.opacity(0.2))
                    AxisValueLabel()
                        .foregroundStyle(ColorPalette.textTertiary)
                        .font(NeumorphicTheme.Font.caption)
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(ColorPalette.shadowDark.opacity(0.2))
                    AxisValueLabel()
                        .foregroundStyle(ColorPalette.textTertiary)
                        .font(NeumorphicTheme.Font.caption)
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let x = value.location.x
                                    if let date: Date = proxy.value(atX: x) {
                                        selectedPoint = findClosestPoint(to: date)
                                    }
                                }
                                .onEnded { _ in
                                    selectedPoint = nil
                                }
                        )
                }
            }
            .frame(height: 200)
        }
    }

    private func selectedPointView(_ point: PricePoint) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("$\(point.formattedPrice)")
                    .font(NeumorphicTheme.Font.titleMedium)
                    .fontWeight(.bold)
                    .foregroundColor(ColorPalette.textPrimary)

                Text(point.formattedDate)
                    .font(NeumorphicTheme.Font.caption)
                    .foregroundColor(ColorPalette.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, NeumorphicTheme.Spacing.xs)
    }

    private func findClosestPoint(to date: Date) -> PricePoint? {
        pricePoints.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })
    }
}

/// Range selector for chart timeframes
struct ChartRangeSelector: View {
    @Binding var selectedRange: PriceHistoryRange

    var body: some View {
        HStack(spacing: NeumorphicTheme.Spacing.xs) {
            ForEach(PriceHistoryRange.allCases) { range in
                RangeSelectorButton(
                    title: range.rawValue,
                    isSelected: selectedRange == range
                ) {
                    HapticManager.selectionChanged()
                    withAnimation(NeumorphicTheme.Animation.quick) {
                        selectedRange = range
                    }
                }
            }
        }
    }
}

private struct RangeSelectorButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(NeumorphicTheme.Font.caption)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .white : ColorPalette.textSecondary)
                .padding(.horizontal, NeumorphicTheme.Spacing.sm)
                .padding(.vertical, NeumorphicTheme.Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: NeumorphicTheme.CornerRadius.small)
                        .fill(isSelected ? ColorPalette.accentBlue : ColorPalette.background)
                )
                .neumorphicShadow(isPressed: isSelected, cornerRadius: NeumorphicTheme.CornerRadius.small)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        ColorPalette.background.ignoresSafeArea()
        VStack {
            PriceChartView(
                pricePoints: (0..<30).map { i in
                    PricePoint(
                        date: Date().addingTimeInterval(-Double(30 - i) * 86400),
                        price: 45000 + Double.random(in: -2000...2000)
                    )
                },
                isPositive: true
            )
            .padding()
        }
    }
}
