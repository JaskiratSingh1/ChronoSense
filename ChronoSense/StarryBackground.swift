import SwiftUI

struct StarryBackground: View {
    @State private var animateStars = false

    var body: some View {
        GeometryReader { geometry in
            let screenSize = max(geometry.size.width, geometry.size.height)
            let dynamicEndRadius = screenSize * 0.8  // 🔵 Scales with screen size

            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [Color.black, Color.indigo.opacity(0.7)]),
                    center: .center,
                    startRadius: 2,
                    endRadius: dynamicEndRadius  // 🔵 Dynamically scales
                )
                .ignoresSafeArea()

                ForEach(0..<100, id: \.self) { _ in
                    Circle()
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(animateStars ? 0.3 : 0.7)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...5)).repeatForever(),
                            value: animateStars
                        )
                }
            }
            .onAppear {
                animateStars.toggle()
            }
        }
    }
}

#Preview {
    StarryBackground()
}
