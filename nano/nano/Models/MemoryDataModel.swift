import Combine
import Foundation

public class MemoryDataModel: ObservableObject {
    @Published public var usagePercentage: Double = 0.0
    @Published public var totalMemoryFormatted: String = "0 GB"
    @Published public var usedMemoryFormatted: String = "0 GB"
    @Published public var memoryBreakdown: SystemMemoryMonitor.MemoryBreakdown?
    @Published public var memoryHistory: [Double] = Array(
        repeating: 0,
        count: 60
    )

    @Published public var cpuUserPercentage: Double = 0.0
    @Published public var cpuSystemPercentage: Double = 0.0
    @Published public var cpuTotalPercentage: Double = 0.0
    @Published public var cpuHistory: [Double] = Array(repeating: 0, count: 60)

    @Published public var batteryPercentage: Double = 0.0
    @Published public var batteryIsCharging: Bool = false
    @Published public var batteryTimeRemaining: TimeInterval? = nil
    @Published public var systemUptime: TimeInterval = 0.0
    @Published public var statusBarTitle: String = "􀫖 0%"

    private let memoryMonitor = SystemMemoryMonitor()
    private let cpuMonitor = CPUMonitor()
    private let batteryMonitor = BatteryMonitor()
    private var totalPhysicalMemory: UInt64 = 0
    private var updateTimer: Timer?

    public init() {
        totalPhysicalMemory = memoryMonitor.fetchTotalPhysicalMemory()
        refresh()
        startPeriodicUpdates()
    }

    private func startPeriodicUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in
            self?.refresh()
        }
    }

    public func refresh() {
        guard let breakdown = memoryMonitor.fetchMemoryBreakdown() else {
            return
        }
        let cpuUsage = cpuMonitor.fetchCPUUsage()
        let batteryInfo = batteryMonitor.fetchBatteryInfo()

        DispatchQueue.main.async {
            self.usagePercentage = breakdown.usage_percentage
            self.memoryBreakdown = breakdown

            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useGB]
            formatter.countStyle = .memory
            formatter.zeroPadsFractionDigits = false

            self.totalMemoryFormatted = formatter.string(
                fromByteCount: Int64(breakdown.total_bytes)
            )
            self.usedMemoryFormatted = formatter.string(
                fromByteCount: Int64(breakdown.used_bytes)
            )

            if let cpuUsage = cpuUsage {
                self.cpuUserPercentage = cpuUsage.userPercentage
                self.cpuSystemPercentage = cpuUsage.systemPercentage
                self.cpuTotalPercentage = cpuUsage.totalPercentage

                // Update CPU history
                self.cpuHistory.removeFirst()
                self.cpuHistory.append(cpuUsage.totalPercentage)
            }

            // Update memory history
            self.memoryHistory.removeFirst()
            self.memoryHistory.append(breakdown.usage_percentage)

            // Update status bar title
            self.statusBarTitle = "􀫖 \(Int(breakdown.usage_percentage))%"

            // Update battery info
            if let batteryInfo = batteryInfo {
                self.batteryPercentage = batteryInfo.percentage
                self.batteryIsCharging = batteryInfo.isCharging
                self.batteryTimeRemaining = batteryInfo.timeRemaining
                self.systemUptime = batteryInfo.uptime
            }
        }
    }
}
