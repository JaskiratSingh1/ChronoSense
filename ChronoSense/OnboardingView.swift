import SwiftUI

struct OnboardingView: View {
    // We observe this variable so we can dismiss the onboarding
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color.indigo
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Welcome to Chrono Sense!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                
                Text("""
                    This app lets you test your internal sense of time. 
                    1. Select a target number of seconds. 
                    2. Tap Start. 
                    3. Tap Stop when you believe that much time has elapsed.
                    """)
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fontDesign(.default)
                .padding(.horizontal)
                
                Button("Got it") {
                    // Dismiss this view
                    isPresented = false
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.green)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

