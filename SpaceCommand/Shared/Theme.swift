import SwiftUI

enum Palette {
    static let bg = Color(red: 0.020, green: 0.027, blue: 0.051)
    static let bg2 = Color(red: 0.039, green: 0.055, blue: 0.102)
    static let panel = Color(red: 0.071, green: 0.094, blue: 0.157)
    static let panelSolid = Color(red: 0.055, green: 0.075, blue: 0.125)

    static let text = Color(red: 0.918, green: 0.949, blue: 1.0)
    static let muted = Color(red: 0.541, green: 0.600, blue: 0.722)
    static let faint = Color(red: 0.337, green: 0.400, blue: 0.522)

    static let accent = Color(red: 0.227, green: 0.839, blue: 1.0)
    static let accent2 = Color(red: 0.486, green: 0.420, blue: 1.0)

    static let f9 = Color(red: 0.227, green: 0.839, blue: 1.0)
    static let fh = Color(red: 1.0, green: 0.541, blue: 0.227)
    static let ss = Color(red: 1.0, green: 0.824, blue: 0.227)

    static let go = Color(red: 0.180, green: 0.902, blue: 0.651)
    static let tbd = Color(red: 1.0, green: 0.808, blue: 0.290)
    static let hold = Color(red: 1.0, green: 0.365, blue: 0.424)

    static let stroke = Color.white.opacity(0.08)
    static let strokeStrong = Color.white.opacity(0.16)

    static func familyColor(_ f: RocketFamily) -> Color {
        switch f {
        case .falcon9: return f9
        case .falconHeavy: return fh
        case .starship: return ss
        case .other: return muted
        }
    }

    static func statusColor(_ kind: LaunchStatus.Kind) -> Color {
        switch kind {
        case .go: return go
        case .hold: return hold
        case .tbd: return tbd
        case .unknown: return muted
        }
    }
}

enum Font2 {
    static func orbitron(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        Font.system(size: size, weight: weight, design: .rounded).width(.expanded)
    }

    static func mono(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        Font.system(size: size, weight: weight, design: .monospaced)
    }

    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.system(size: size, weight: weight, design: .default)
    }
}

struct PanelStyle: ViewModifier {
    var radius: CGFloat = 16
    var strong: Bool = false
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(Palette.panel.opacity(strong ? 0.85 : 0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(strong ? Palette.strokeStrong : Palette.stroke, lineWidth: 0.5)
            )
    }
}

extension View {
    func panel(radius: CGFloat = 16, strong: Bool = false) -> some View {
        modifier(PanelStyle(radius: radius, strong: strong))
    }
}

struct AccentGradient: View {
    var body: some View {
        Self.style
    }

    static let style = LinearGradient(
        colors: [Palette.accent, Palette.accent2],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
