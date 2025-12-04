//
//  nanoApp.swift
//  nano
//
//  Created by tnixc on 5/10/2025.
//

import SwiftUI

@main
struct nanoApp: App {
    @StateObject private var menuBarModel = MemoryDataModel()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(memoryMonitor: menuBarModel)
                .background(.clear)
                .focusable(false)
        } label: {
            MenuBarCPULabel(
                cpuHistory: menuBarModel.cpuHistory,
                cpuPercentage: menuBarModel.cpuTotalPercentage
            )
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - Menu Bar CPU Label

struct MenuBarCPULabel: View {
    let cpuHistory: [Double]
    let cpuPercentage: Double

    var body: some View {
        if let combinedImage = createCombinedImage() {
            Image(nsImage: combinedImage)
                .resizable()
                .frame(width: 50, height: 16)
                .focusable(false)
        }
    }

    private func createCombinedImage() -> NSImage? {
        let graphWidth: CGFloat = 50
        let height: CGFloat = 16

        let size = NSSize(width: graphWidth, height: height)
        let image = NSImage(size: size)

        image.lockFocus()
        defer { image.unlockFocus() }

        // Background rounded rectangle for graph
        NSColor.white.withAlphaComponent(0.2).setFill()
        let bgPath = NSBezierPath(
            roundedRect: NSRect(x: 0, y: 0, width: graphWidth, height: height),
            xRadius: 3,
            yRadius: 3
        )
        bgPath.fill()

        // Subtle border
        NSColor.white.withAlphaComponent(0.3).setStroke()
        let borderPath = NSBezierPath(
            roundedRect: NSRect(x: 0.5, y: 0.5, width: graphWidth - 1, height: height - 1),
            xRadius: 3,
            yRadius: 3
        )
        borderPath.lineWidth = 1
        borderPath.stroke()

        // Draw smooth area chart
        let last30 = Array(cpuHistory.suffix(30))
        if !last30.isEmpty {
            let barWidth: CGFloat = graphWidth / CGFloat(last30.count)

            NSColor.white.setFill()

            let path = NSBezierPath()

            // Start from bottom left corner
            path.move(to: NSPoint(x: 0, y: 0))

            // Draw the area - first point
            if let firstValue = last30.first {
                let normalizedValue = min(max(firstValue, 0), 100) / 100.0
                let y = height * normalizedValue
                path.line(to: NSPoint(x: 0, y: y))
            }

            // Draw the rest of the points
            for (index, value) in last30.enumerated() {
                let x = CGFloat(index) * barWidth
                let normalizedValue = min(max(value, 0), 100) / 100.0
                let y = height * normalizedValue
                path.line(to: NSPoint(x: x, y: y))
            }

            // Close the path back to bottom right corner
            path.line(to: NSPoint(x: graphWidth, y: 0))
            path.close()

            path.fill()
        }

        return image
    }
}
