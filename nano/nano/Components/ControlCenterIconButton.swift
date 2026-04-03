import MaterialView
import SwiftUI

struct ControlCenterIconButton: View {
    let icon: String
    let action: () -> Void
    var destructive: Bool = false

    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                MaterialView(
                    effect: NanoMaterialTheme.panelEffect(for: colorScheme),
                    cornerRadius: 22
                )

                Circle()
                    .fill(
                        destructive
                            ? (isHovered ? Color.red.opacity(0.14) : Color.clear)
                            : (isHovered ? Color.primary.opacity(0.08) : Color.clear)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                destructive && isHovered
                                    ? Color.red.opacity(0.3)
                                    : Color.clear,
                                lineWidth: 1
                            )
                    )

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(destructive && isHovered ? .red : .primary)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
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
