import SwiftUI

struct BatteryStatsRow: View {
    let batteryPercentage: Double
    let isCharging: Bool
    let timeRemaining: TimeInterval?
    let uptime: TimeInterval

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(
                    systemName: isCharging ? "battery.100.bolt" : "battery.100"
                )
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)

                Text("Battery")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Battery percentage bar
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    Text(isCharging ? "Charging" : "Battery")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: geometry.size.width, height: 6)

                            LinearGradient(
                                colors: [
                                    Color(
                                        red: 0xD1 / 255,
                                        green: 0xF2 / 255,
                                        blue: 0x67 / 255
                                    ),
                                    Color(
                                        red: 0x71 / 255,
                                        green: 0xDD / 255,
                                        blue: 0x67 / 255
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
                                            * CGFloat(batteryPercentage / 100.0),
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

                    Text("\(Int(batteryPercentage))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                }
            }
            .padding(.horizontal, 16)

            // Uptime and time remaining
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Uptime")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(BatteryMonitor.formatUptime(uptime))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                }

                HStack {
                    Text(isCharging ? "Time to Full" : "Time Left")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text(
                        BatteryMonitor.formatTimeRemaining(
                            timeRemaining,
                            isCharging: isCharging
                        )
                    )
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                    .monospacedDigit()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}
