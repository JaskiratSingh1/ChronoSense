import SwiftUI

struct ResultsView: View {
    let targetTime: Double
    let actualTime: Double
    
    @ObservedObject var resultsStore: ResultsStore
    @State private var showHistory = false

    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height

            ZStack {
                // Background
                StarryBackground()

                VStack(spacing: screenHeight * 0.03) {
                    // Title
                    Text("Results")
                        .font(.system(size: screenHeight * 0.09, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, screenHeight * 0.02)

                    // Target Time
                    Text("Target Time: \(Int(targetTime))s")
                        .font(.system(size: screenHeight * 0.045, weight: .medium))
                        .foregroundColor(.white)

                    // Actual Time
                    Text("Your Time: \(String(format: "%.2f", actualTime))s")
                        .font(.system(size: screenHeight * 0.045, weight: .medium))
                        .foregroundColor(.white)

                    // Difference
                    let difference = abs(actualTime - targetTime)
                    Text("Difference: \(String(format: "%.2f", difference))s")
                        .font(.system(size: screenHeight * 0.03, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, screenHeight * 0.01)

                    Spacer()

                    // View History Button
                    Button(action: {
                        showHistory = true
                    }) {
                        Text("View History")
                            .font(.system(size: screenHeight * 0.025, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, screenHeight * 0.015)
                            .padding(.horizontal, screenHeight * 0.05)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(30)
                            .shadow(color: .blue.opacity(0.5), radius: 8, x: 0, y: 3)
                    }
                    .sheet(isPresented: $showHistory) {
                        HistoryView(resultsStore: resultsStore)
                    }
                    .padding(.bottom, screenHeight * 0.03)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Chrono Sense")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
