import SwiftUI

struct GlimmerText: View {
    let text: String
    @State private var animateGradient = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let dynamicFontSize = screenWidth * 0.15
            
            Text(text)
                .font(.system(size: dynamicFontSize, weight: .light, design: .default))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.blue, Color.green],
                        startPoint: animateGradient ? .leading : .trailing,
                        endPoint: animateGradient ? .trailing : .leading
                    )
                )
                .shadow(color: Color.cyan.opacity(0.6), radius: 10, x: 0, y: 0)  // Soft glow
                .padding(.top, 20)
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
        }
    }
}
