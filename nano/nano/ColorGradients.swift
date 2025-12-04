import SwiftUI

// MARK: - Usage Color Constants

enum UsageGradient {
    static let colors: [Color] = [
        Color(red: 0.0, green: 0.5, blue: 1.0), // Blue (0%)
        Color(red: 0.0, green: 0.8, blue: 1.0), // Cyan (25%)
        Color(red: 1.0, green: 0.9, blue: 0.0), // Yellow (50%)
        Color(red: 1.0, green: 0.6, blue: 0.0), // Orange (75%)
        Color(red: 1.0, green: 0.2, blue: 0.0), // Red (100%)
    ]

    static let gradient = LinearGradient(
        colors: colors,
        startPoint: .leading,
        endPoint: .trailing
    )

    static let verticalGradient = LinearGradient(
        colors: colors,
        startPoint: .bottom,
        endPoint: .top
    )

    static func colorForPercentage(_ percentage: Double) -> Color {
        let clamped = min(max(percentage, 0), 100)
        let scaled = clamped / 25.0 // 0-4 range for 5 stops
        let index = Int(scaled)
        let _ = scaled - Double(index)

        if index >= colors.count - 1 {
            return colors.last ?? colors[0]
        }

        return colors[index]
    }
}

enum BatteryGradient {
    static func gradientForPercentage(_ percentage: Double) -> LinearGradient {
        let clamped = min(max(percentage, 0), 100)

        if clamped >= 80 {
            // 80%-100%: light green to green
            return LinearGradient(
                colors: [
                    Color(red: 0.6, green: 0.9, blue: 0.6), // Light green
                    Color(red: 0.2, green: 0.8, blue: 0.2), // Green
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else if clamped >= 60 {
            // 60%-80%: yellow to light green
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.9, blue: 0.0), // Yellow
                    Color(red: 0.6, green: 0.9, blue: 0.6), // Light green
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else if clamped >= 40 {
            // 40%-60%: orange to yellow
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.6, blue: 0.0), // Orange
                    Color(red: 1.0, green: 0.9, blue: 0.0), // Yellow
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else if clamped >= 20 {
            // 20%-40%: red to orange
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.2, blue: 0.0), // Red
                    Color(red: 1.0, green: 0.6, blue: 0.0), // Orange
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            // 0%-20%: dark red to red
            return LinearGradient(
                colors: [
                    Color(red: 0.8, green: 0.1, blue: 0.1), // Dark red
                    Color(red: 1.0, green: 0.2, blue: 0.0), // Red
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    static func colorForPercentage(_ percentage: Double) -> Color {
        let clamped = min(max(percentage, 0), 100)

        if clamped >= 80 {
            return Color(red: 0.2, green: 0.8, blue: 0.2) // Green
        } else if clamped >= 60 {
            return Color(red: 0.6, green: 0.9, blue: 0.6) // Light green
        } else if clamped >= 40 {
            return Color(red: 1.0, green: 0.9, blue: 0.0) // Yellow
        } else if clamped >= 20 {
            return Color(red: 1.0, green: 0.6, blue: 0.0) // Orange
        } else {
            return Color(red: 1.0, green: 0.2, blue: 0.0) // Red
        }
    }
}
