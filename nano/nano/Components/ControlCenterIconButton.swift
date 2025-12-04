import SwiftUI

struct ControlCenterIconButton: View {
    let icon: String
    let action: () -> Void
    var destructive: Bool = false

    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        destructive
                            ? (isHovered
                                ? Color.red.opacity(0.15)
                                : Color.secondary.opacity(0.08))
                            : (isHovered
                                ? Color.primary.opacity(0.12)
                                : Color.secondary.opacity(0.08))
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                destructive && isHovered
                                    ? Color.red.opacity(0.3)
                                    : Color.white.opacity(
                                        isHovered ? 0.25 : 0.15
                                    ),
                                lineWidth: 1
                            )
                    )

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(destructive && isHovered ? .red : .primary)
            }
            .frame(width: 44, height: 44)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .focusable(false)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .pressEvents(
            onPress: {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
            },
            onRelease: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        )
    }
}

// MARK: - Press Events Modifier

extension View {
    func pressEvents(
        onPress: @escaping () -> Void,
        onRelease: @escaping () -> Void
    ) -> some View {
        simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onPress()
                }
                .onEnded { _ in
                    onRelease()
                }
        )
    }
}
