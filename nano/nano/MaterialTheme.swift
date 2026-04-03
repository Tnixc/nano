import AppKit
import MaterialView
import SwiftUI

enum NanoMaterialTheme {
    static func panelEffect(for colorScheme: ColorScheme) -> NSMaterialView.Effect {
        colorScheme == .dark ? macOSDarkBackground : macOSLightBackground
    }

    /// Presets copied from MaterialView demo (macOS Dark / macOS Light)
    private static let macOSDarkBackground = NSMaterialView.Effect(
        active: NSMaterialView.Effect.MaterialStyle(
            backgroundColor: NSColor.rgbGray(gray: 0.1369, alpha: 0.4),
            tintColor: NSColor.rgbGray(gray: 0.08627, alpha: 0.5),
            tintFilter: kCAFilterLightenBlendMode,
            saturationFactor: 1.6,
            brightnessFactor: 0.025,
            blurRadius: 30
        ),
        rimColor: (NSColor.rgbGray(gray: 1, alpha: 0.1), .clear),
        rimWidth: (1, 0)
    )

    private static let macOSLightBackground = NSMaterialView.Effect(
        active: NSMaterialView.Effect.MaterialStyle(
            backgroundColor: NSColor.rgbGray(gray: 0.8896, alpha: 0.4),
            tintColor: NSColor.rgbGray(gray: 1, alpha: 0.12),
            tintFilter: kCAFilterDarkenBlendMode,
            saturationFactor: 1.6,
            brightnessFactor: -0.01,
            blurRadius: 30
        ),
        rimColor: (
            NSColor.white.withAlphaComponent(0.1),
            NSColor.black.withAlphaComponent(0.1)
        ),
        rimWidth: (0.5, 0.5)
    )
}

private struct NanoMaterialCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background {
                MaterialView(
                    effect: NanoMaterialTheme.panelEffect(for: colorScheme),
                    cornerRadius: cornerRadius
                )
            }
            .panelShadow(cornerRadius: cornerRadius, isDark: colorScheme == .dark)
    }
}

extension View {
    /// From MaterialView demo: masked outer shadow that doesn't muddy the panel interior.
    func boxShadow(
        _ mask: some View,
        color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33),
        radius: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> some View {
        background(
            mask
                .padding(1)
                .shadow(color: color, radius: radius, x: x, y: y)
                .mask(
                    mask
                        .foregroundColor(.black)
                        .padding(0.5)
                        .background(
                            mask
                                .foregroundColor(.white)
                                .padding(-radius * 3)
                        )
                        .compositingGroup()
                        .luminanceToAlpha()
                )
        )
    }

    func panelShadow(cornerRadius: CGFloat, isDark: Bool) -> some View {
        boxShadow(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            color: .black.opacity(0.18),
            radius: isDark ? 2 : 10,
            y: 2
        )
        .boxShadow(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            color: .black.opacity(0.08),
            radius: 2,
            y: 0
        )
    }

    func nanoMaterialCard(cornerRadius: CGFloat = 14) -> some View {
        modifier(NanoMaterialCardModifier(cornerRadius: cornerRadius))
    }
}
