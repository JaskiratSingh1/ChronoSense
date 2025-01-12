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
            Text("Your Previous Attempts")
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
                            HStack{
                                VStack(alignment: .leading) {
                                    // Show the actual time
                                    Text("**Actual:** \(String(format: "%.2f", result.actualTime)) s")
                                    // Show the chosen (target) time
                                    Text("**Target:** \(result.targetTime) s")
                                }
                                .font(.title3)
                                .padding(.vertical, 5)
                                
                                Spacer()
                                VStack{
                                    Spacer()
                                    
                                    // Show the date/time
                                    Text("**Date:** \(dateFormatter.string(from: result.timestamp))")
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                            }
                            
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
