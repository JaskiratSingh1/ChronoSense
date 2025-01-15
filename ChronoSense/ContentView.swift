import SwiftUI

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
    @State private var selectedIndex: Int = 0
    
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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // MARK: -- Time Options
                if isRunning {
                    // Show only the selected time in large text
                    Text("\(times[selectedIndex])s")
                        .font(.system(size: 50, weight: .bold))
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
                                        selectedIndex = index
                                        withAnimation {
                                            scrollProxy.scrollTo(index, anchor: .center)
                                        }
                                    }
                                }
                                
                                // Clear frame padding to center last option
                                Color.clear
                                    .frame(width: (UIScreen.main.bounds.size.width - UIScreen.main.bounds.height * 0.12) / 2.0, height: 0)
                            }
                            .frame(maxWidth: .infinity)
                            .defaultScrollAnchor(.center)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // MARK: -- Start/Stop Button
                Button(action: {
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
                    Text(isRunning ? "Stop" : "Start")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.15)
                        .foregroundColor(.white)
                        .background(isRunning ? Color.red : Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Show previous results
                Button("View History") {
                    showHistory = true
                }
                .sheet(isPresented: $showHistory) {
                    HistoryView(resultsStore: resultsStore)
                }
            }
            .padding()
            .navigationTitle("Chrono Sense")
            // This triggers navigation when `showResults` becomes true
            .navigationDestination(isPresented: $showResults) {
                ResultsView(
                    targetTime: Double(times[selectedIndex]),
                    actualTime: actualTime,
                    resultsStore: resultsStore
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
