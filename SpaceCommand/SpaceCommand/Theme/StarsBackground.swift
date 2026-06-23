import SwiftUI

struct StarsBackground: View {
    @State private var phase: CGFloat = 0
    private let stars: [Star] = (0..<140).map { _ in
        Star(
            x: .random(in: 0...1),
            y: .random(in: 0...1),
            size: CGFloat.random(in: 0.6...2.0),
            opacity: Double.random(in: 0.25...0.95),
            twinkleSpeed: Double.random(in: 1.6...4.4)
        )
    }

    struct Star: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
        let twinkleSpeed: Double
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Palette.bg.ignoresSafeArea()
                LinearGradient(
                    colors: [Palette.bg, Palette.bg2, Palette.bg],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()

                Canvas { ctx, size in
                    for star in stars {
                        let x = star.x * size.width
                        let y = star.y * size.height
                        let alpha = 0.4 + 0.6 * abs(sin(phase / star.twinkleSpeed + star.x * 6))
                        let rect = CGRect(
                            x: x - star.size / 2,
                            y: y - star.size / 2,
                            width: star.size,
                            height: star.size
                        )
                        ctx.fill(Path(ellipseIn: rect),
                                 with: .color(.white.opacity(star.opacity * alpha)))
                    }
                }
                .ignoresSafeArea()

                Circle()
                    .fill(Palette.accent.opacity(0.20))
                    .frame(width: 420, height: 420)
                    .blur(radius: 90)
                    .offset(x: geo.size.width * 0.35, y: -geo.size.height * 0.35)
                Circle()
                    .fill(Palette.accent2.opacity(0.18))
                    .frame(width: 460, height: 460)
                    .blur(radius: 100)
                    .offset(x: -geo.size.width * 0.4, y: geo.size.height * 0.4)
            }
            .onAppear {
                withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                    phase = 100
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    StarsBackground()
}
