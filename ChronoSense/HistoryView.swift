import SwiftUI

struct HistoryView: View {
    @ObservedObject var resultsStore: ResultsStore
    
    // A simple date formatter
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    var body: some View {
        VStack {
            Text("Your Previous Best Times")
                .font(.title2)
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if resultsStore.results.isEmpty {
                        Text("No results yet.")
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                    } else {
                        ForEach(resultsStore.results) { result in
                            VStack(alignment: .leading) {
                                Text("**Time:** \(String(format: "%.2f", result.time))s")
                                Text("**Date:** \(dateFormatter.string(from: result.timestamp))")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 5)
                            
                            Divider()
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Button at the bottom to reset all data
            Button(role: .destructive) {
                resultsStore.resetAll()
            } label: {
                Text("Reset All Data")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}
