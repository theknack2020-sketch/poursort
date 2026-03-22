import SwiftUI

struct TubeView: View {
    let tube: Tube
    let isSelected: Bool
    let isComplete: Bool
    let namespace: Namespace.ID

    var body: some View {
        ZStack(alignment: .bottom) {
            // Glass tube container
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pourTube.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            isComplete ? Color.green.opacity(0.6) :
                            isSelected ? Color.pourPrimary :
                            Color.white.opacity(0.1),
                            lineWidth: isSelected || isComplete ? 2 : 1
                        )
                )
                .shadow(
                    color: isComplete ? Color.green.opacity(0.3) :
                           isSelected ? Color.pourPrimary.opacity(0.3) : .clear,
                    radius: 8
                )

            // Balls
            VStack(spacing: 4) {
                ForEach(tube.balls.reversed()) { ball in
                    BallView(ball: ball)
                        .matchedGeometryEffect(id: ball.id, in: namespace)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 8)
        }
        .frame(height: CGFloat(tube.capacity) * 38 + 20)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.5), value: isComplete)
    }
}

struct BallView: View {
    let ball: Ball
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            ball.ballColor.color.opacity(0.8),
                            ball.ballColor.color,
                            ball.ballColor.color.opacity(0.7)
                        ],
                        center: .init(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: 18
                    )
                )
                .shadow(color: ball.ballColor.color.opacity(0.4), radius: 3, y: 2)

            // Specular highlight
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.5), .clear],
                        center: .init(x: 0.3, y: 0.3),
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 14, height: 14)
                .offset(x: -4, y: -4)

            // Accessibility symbol overlay
            if differentiateWithoutColor {
                Image(systemName: ball.ballColor.symbol)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .frame(width: 30, height: 30)
    }
}
