import SwiftUI

struct ContentView: View {
    // All possible times (5s to 100s in 5s increments)
    @State private var times: [Int] = Array(stride(from: 5, through: 100, by: 5))
    
    // Index of the currently selected time
    @State private var selectedIndex: Int = 0
    
    // Whether the timer is running
    @State private var isRunning: Bool = false
    @State private var startDate: Date? = nil
    
    // Measured actual time when user presses stop
    @State private var actualTime: Double = 0.0
    
    // Controls navigation to the results screen
    @State private var showResults: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                // MARK: -- Time Options
                if isRunning {
                    // Show only the selected time in large text
                    Text("\(times[selectedIndex])s")
                        .font(.system(size: 50, weight: .bold))
                } else {
                    // Show all times horizontally; the selected is larger and bolder
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(times.indices, id: \.self) { index in
                                let isSelected = (index == selectedIndex)
                                Text("\(times[index])s")
                                    .font(.system(size: isSelected ? 40 : 20,
                                                  weight: isSelected ? .bold : .regular))
                                    .foregroundColor(isSelected ? .blue : .gray)
                                    .onTapGesture {
                                        selectedIndex = index
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
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
                        
                        isRunning = false
                        // Go to results screen
                        showResults = true
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .foregroundColor(.white)
                        .background(isRunning ? Color.red : Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Chrono Sense")
            // This triggers navigation when `showResults` becomes true
            .navigationDestination(isPresented: $showResults) {
                ResultsView(
                    targetTime: Double(times[selectedIndex]),
                    actualTime: actualTime
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
