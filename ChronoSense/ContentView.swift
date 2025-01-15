import SwiftUI
import UIKit
import AudioToolbox

// MARK: -- Time Option Button
struct TimeButton: View {
    let time: Int
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        // 🔵 Dynamic size calculation based on screen height
        let screenHeight = UIScreen.main.bounds.height
        let baseSize: CGFloat = isSelected ? 0.25 : 0.15
        let buttonSize = screenHeight * baseSize
        let fontSize = screenHeight * (isSelected ? 0.08 : 0.05)
        
        ZStack {
            Circle()
                .foregroundColor(isSelected ? .indigo : .gray)
            Text("\(time)s")
                .font(.system(size: fontSize, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .mint : .white)
        }
        .frame(width: buttonSize, height: buttonSize)
        .onTapGesture {
            onSelect()
        }
    }
}

struct ContentView: View {
    // All possible times (5s to 100s in 5s increments)
    @State private var times: [Int] = Array(stride(from: 5, through: 90, by: 5))
    
    // Index of the currently selected time
    @State private var selectedIndex: Int = 1
    
    // Whether the timer is running
    @State private var isRunning: Bool = false
    @State private var startDate: Date? = nil
    
    // Measured actual time when user presses stop
    @State private var actualTime: Double = 0.0
    
    // Controls navigation to the results screen
    @State private var showResults: Bool = false
    
    // Controls navigation to history screen
    @State private var showHistory = false
    
    // Env var for results
    @StateObject private var resultsStore = ResultsStore()
    
    // Time tracking for scroll haptics
    @State private var lastHapticTime: Date = Date()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Page background
                StarryBackground()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // MARK: -- Time Options
                    if isRunning {
                        let screenHeight = UIScreen.main.bounds.height
                        let dynamicFontSize = screenHeight * 0.10
                        
                        Text("\(times[selectedIndex])s")
                            .font(.system(size: dynamicFontSize, weight: .bold))
                            .foregroundColor(.white)  // ✅ Ensures the text stays white
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    } else {
                        // Show all times horizontally; the selected is larger and bolder
                        ScrollViewReader { scrollProxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 30) {
                                    // Clear frame padding to center first option
                                    Color.clear
                                        .frame(width: (UIScreen.main.bounds.size.width - UIScreen.main.bounds.height * 0.12) / 2.0, height: 0)
                                    
                                    ForEach(times.indices, id: \.self) { index in
                                        TimeButton(
                                            time: times[index],
                                            isSelected: index == selectedIndex
                                        ) {
                                            if selectedIndex != index {
                                                selectedIndex = index
                                                triggerHapticFeedback()
                                                playClickSound()
                                                
                                                withAnimation {
                                                    scrollProxy.scrollTo(index, anchor: .center)
                                                }
                                            }
                                        }
                                    }
                                    
                                    // Clear frame padding to center last option
                                    Color.clear
                                        .frame(width: (UIScreen.main.bounds.size.width - UIScreen.main.bounds.height * 0.12) / 2.0, height: 0)
                                }
                                .frame(maxWidth: .infinity)
                                .background(ScrollDetector())
                            }
                            .onAppear {
                                scrollProxy.scrollTo(selectedIndex, anchor: .center)
                            }
                        }
                    }
                    
                    // MARK: -- Start/Stop Button
                    Button(action: {
                        // Play sound and haptic
                        triggerHapticFeedback()
                        playClickSound()
                        
                        if !isRunning {
                            // Start timer
                            isRunning = true
                            startDate = Date()
                        } else {
                            // Stop timer
                            let now = Date()
                            if let startDate = startDate {
                                actualTime = now.timeIntervalSince(startDate)
                            } else {
                                actualTime = 0
                            }
                            
                            // Store the results
                            resultsStore.addResult(targetTime: times[selectedIndex],
                                                   actualTime: actualTime)
                            
                            isRunning = false
                            // Go to results screen
                            showResults = true
                        }
                    }) {
                        let screenHeight = UIScreen.main.bounds.height
                        let buttonFontSize = screenHeight * 0.06
                        
                        Text(isRunning ? "Stop" : "Start")
                            .font(.system(size: buttonFontSize, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.15)
                            .foregroundColor(.white)
                            .background(isRunning ? Color.red : Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Show previous results
                    Button(action: {
                        showHistory = true
                    }) {
                        Text("View History")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white) // White text
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.cyan) // Customize the background color
                            .cornerRadius(25) // Pill shape
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .sheet(isPresented: $showHistory) {
                        HistoryView(resultsStore: resultsStore)
                    }
                }
                .navigationBarTitleDisplayMode(.inline) // Keeps it sleek and centered
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        GlimmerText(text: "Chrono Sense")
                        .frame(height: 40)
                    }
                }
                .shadow(color: Color.purple.opacity(0.45), radius: 8, x: 0, y: 0)
                // This triggers navigation when `showResults` becomes true
                .navigationDestination(isPresented: $showResults) {
                    ResultsView(
                        targetTime: Double(times[selectedIndex]),
                        actualTime: actualTime,
                        resultsStore: resultsStore
                    )
                }
                .onAppear {
                    // Force the toolbar to refresh
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                }
            }
        }
    }
    
    // MARK: -- Haptic Feedback
    func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    // MARK: -- Sound Feedback
    func playClickSound() {
        AudioServicesPlaySystemSound(1113)
    }
}

struct ScrollDetector: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let scrollView = view.enclosingScrollView() {
                scrollView.delegate = context.coordinator
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        private var lastHapticTime = Date()

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let now = Date()
            if now.timeIntervalSince(lastHapticTime) > 0.3 {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
                lastHapticTime = now
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        if let scrollView = self.superview as? UIScrollView {
            return scrollView
        }
        return self.superview?.enclosingScrollView()
    }
}

#Preview {
    ContentView()
}
