// macos/Sources/UI/MenuBarView.swift
import SwiftUI

struct MenuBarView: View {
    @ObservedObject var memoryMonitor: MemoryDataModel
    @StateObject private var launchAtLogin = LaunchAtLoginViewModel()
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 10) {
            // CPU Stats Card
            VStack(spacing: 0) {
                CPUStatsRow(
                    userPercentage: memoryMonitor.cpuUserPercentage,
                    systemPercentage: memoryMonitor.cpuSystemPercentage,
                    totalPercentage: memoryMonitor.cpuTotalPercentage,
                    history: memoryMonitor.cpuHistory
                )
            }
            .nanoMaterialCard(cornerRadius: 14)

            // Memory Stats Card
            VStack(spacing: 0) {
                MemoryStatsRow(
                    memoryBreakdown: memoryMonitor.memoryBreakdown,
                    usagePercentage: memoryMonitor.usagePercentage,
                    memoryHistory: memoryMonitor.memoryHistory
                )
            }
            .nanoMaterialCard(cornerRadius: 14)

            // Battery Stats Card
            VStack(spacing: 0) {
                BatteryStatsRow(
                    batteryPercentage: memoryMonitor.batteryPercentage,
                    isCharging: memoryMonitor.batteryIsCharging,
                    timeRemaining: memoryMonitor.batteryTimeRemaining,
                    uptime: memoryMonitor.systemUptime
                )
            }
            .nanoMaterialCard(cornerRadius: 14)

            // Settings Card (if showing)
            if showingSettings {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Settings")
                            .font(.system(size: 13, weight: .semibold))
                        Spacer()
                    }

                    Toggle(
                        isOn: Binding(
                            get: { launchAtLogin.isEnabled },
                            set: { _ in launchAtLogin.toggle() }
                        )
                    ) {
                        Text("Launch at Login")
                            .font(.system(size: 12))
                    }
                    .toggleStyle(.switch)
                    .focusable(false)
                }
                .padding(16)
                .nanoMaterialCard(cornerRadius: 14)
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.95, anchor: .top).combined(
                            with: .opacity
                        ),
                        removal: .scale(scale: 0.95, anchor: .top).combined(
                            with: .opacity
                        )
                    )
                )
            }

            // Bottom Actions
            HStack(spacing: 10) {
                ControlCenterIconButton(
                    icon: "arrow.clockwise",
                    action: {
                        memoryMonitor.refresh()
                    }
                )

                Spacer()

                ControlCenterIconButton(
                    icon: "gearshape",
                    action: {
                        withAnimation(
                            .spring(response: 0.35, dampingFraction: 0.8)
                        ) {
                            showingSettings.toggle()
                        }
                    }
                )

                ControlCenterIconButton(
                    icon: "xmark",
                    action: {
                        NSApplication.shared.terminate(nil)
                    },
                    destructive: true
                )
            }
        }
        .padding(10)
        .frame(width: 320)
        .focusable(false)
    }
}
