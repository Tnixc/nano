import SwiftUI

struct VerticalBarGraph: View {
    let history: [Double]
    var height: CGFloat = 40.0

    var body: some View {
        GeometryReader { geometry in
            let maxValue = 100.0  // Percentage scale
            let barWidth = geometry.size.width / CGFloat(history.count)

            ZStack(alignment: .bottom) {
                // Background
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.secondary.opacity(0.15))

                // Grid lines at 25%, 50%, 75%, 100%
                Path { path in
                    // 75% line (25% from bottom)
                    let y75 = height * 0.25
                    path.move(to: CGPoint(x: 0, y: y75))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y75))

                    // 50% line (50% from bottom)
                    let y50 = height * 0.5
                    path.move(to: CGPoint(x: 0, y: y50))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y50))

                    // 25% line (75% from bottom)
                    let y25 = height * 0.75
                    path.move(to: CGPoint(x: 0, y: y25))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y25))
                }
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                .foregroundColor(Color.gray.opacity(0.3))

                HStack(alignment: .bottom, spacing: 1) {
                    ForEach(Array(history.enumerated()), id: \.offset) {
                        _,
                        value in
                        let barHeight = max(
                            height * CGFloat(value / maxValue),
                            2
                        )

                        LinearGradient(
                            colors: [
                                Color(
                                    red: 0x6D / 255,
                                    green: 0xC1 / 255,
                                    blue: 0xFB / 255
                                ),
                                Color(
                                    red: 0x3A / 255,
                                    green: 0x7C / 255,
                                    blue: 0xFE / 255
                                ),
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(width: max(barWidth - 1, 1), height: height)
                        .mask(
                            VStack(spacing: 0) {
                                Spacer(minLength: height - barHeight)
                                RoundedRectangle(cornerRadius: 1)
                                    .frame(height: barHeight)
                            }
                            .frame(height: height)
                        )
                    }
                }
            }
        }
        .frame(height: height)
    }
}
