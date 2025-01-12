import SwiftUI


struct ResultsView: View {
    let targetTime: Double
    let actualTime: Double
    
    // Results object
    @ObservedObject var resultsStore: ResultsStore
    
    // Controls navigation to history screen
    @State private var showHistory = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Results")
                .font(.largeTitle)
                .padding(.top)
            
            Text("Target Time: \(Int(targetTime))s")
                .font(.title2)
            Text("Your Time: \(String(format: "%.2f", actualTime))s")
                .font(.title2)
            
            let difference = abs(actualTime - targetTime)
            Text("Difference: \(String(format: "%.2f", difference))s")
                .foregroundColor(.secondary)
                .padding(.top)
            
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
        .navigationBarTitleDisplayMode(.inline)
    }
}
/*
struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let now = Date()
        let then = now.addingTimeInterval(100)
        
        let mockStore = ResultsStore()
        mockStore.addResult(now.timeIntervalSince1970())
        mockStore.addResult(30.47)
        
        ResultsView(targetTime: 30, actualTime: 27.5, resultsStore: mockStore)
    }
}
 
 */
/*
#Preview {
    ResultsView()
}
*/
