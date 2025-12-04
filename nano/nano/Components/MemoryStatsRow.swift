import SwiftUI

struct MemoryStatsRow: View {
    let memoryBreakdown: SystemMemoryMonitor.MemoryBreakdown?
    let usagePercentage: Double
    let memoryHistory: [Double]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "memorychip")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)

                Text("RAM")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Memory chart
            VerticalBarGraph(history: memoryHistory, height: 60)
                .padding(.horizontal, 16)

            // Pressure bar
            VStack(alignment: .leading, spacing: 6) {
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
                                        * CGFloat(usagePercentage / 100.0),
                                    height: 6
                                )
                                .frame(
                                    width: geometry.size.width,
                                    height: 6,
                                    alignment: .leading
                                )
                        )
                    }
                }.padding(.horizontal, 2)
                    .frame(height: 6)
            }
            .padding(.horizontal, 16)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Pressure")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()

                if let breakdown = memoryBreakdown {
                    Text(formatBytesGB(breakdown.used_bytes))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                }

                Text("\(Int(usagePercentage))%")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                    .monospacedDigit()
            }
            .padding(.horizontal, 16)

            if let breakdown = memoryBreakdown {
                MemoryDetailRow(
                    label: "Swap File",
                    value: formatBytesGB(breakdown.swap_used_bytes),
                    showBar: true,
                    barPercentage: breakdown.swap_total_bytes > 0
                        ? Double(breakdown.swap_used_bytes)
                        / Double(breakdown.swap_total_bytes) * 100.0 : 0
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
    }

    private func formatBytesGB(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB]
        formatter.countStyle = .memory
        formatter.zeroPadsFractionDigits = false
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
