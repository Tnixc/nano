import SwiftUI

struct CPUStatsRow: View {
    let userPercentage: Double
    let systemPercentage: Double
    let totalPercentage: Double
    let history: [Double]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "cpu")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)

                Text("CPU")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Sparkline chart
            VerticalBarGraph(history: history, height: 60)
                .padding(.horizontal, 16)

            // User percentage bar
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("User")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 60, alignment: .leading)

                    Text("\(Int(userPercentage))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                        .frame(width: 40, alignment: .trailing)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: geometry.size.width, height: 6)

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
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(
                                width: geometry.size.width,
                                height: 6
                            )
                            .mask(
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(
                                        width: geometry.size.width
                                            * CGFloat(userPercentage / 100.0),
                                        height: 6
                                    )
                                    .frame(
                                        width: geometry.size.width,
                                        height: 6,
                                        alignment: .leading
                                    )
                            )
                        }
                    }
                    .frame(height: 6)
                }

                // System percentage bar
                HStack(spacing: 8) {
                    Text("System")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 60, alignment: .leading)

                    Text("\(Int(systemPercentage))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                        .frame(width: 40, alignment: .trailing)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: geometry.size.width, height: 6)

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
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(
                                width: geometry.size.width,
                                height: 6
                            )
                            .mask(
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(
                                        width: geometry.size.width
                                            * CGFloat(systemPercentage / 100.0),
                                        height: 6
                                    )
                                    .frame(
                                        width: geometry.size.width,
                                        height: 6,
                                        alignment: .leading
                                    )
                            )
                        }
                    }
                    .frame(height: 6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}
