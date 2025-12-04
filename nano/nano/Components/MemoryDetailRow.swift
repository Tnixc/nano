import SwiftUI

struct MemoryDetailRow: View {
    let label: String
    let value: String
    let showBar: Bool
    var barPercentage: Double = 0

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary)
                .monospacedDigit()

            if showBar {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 80, height: 4)

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
                        width: 80,
                        height: 4
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 2)
                            .frame(
                                width: 80
                                    * CGFloat(
                                        min(barPercentage, 100.0)
                                            / 100.0
                                    ),
                                height: 4
                            )
                            .frame(width: 80, height: 4, alignment: .leading)
                    )
                }
                .frame(width: 80, height: 4)
                .padding(.bottom, 3)
            }
        }
    }
}
