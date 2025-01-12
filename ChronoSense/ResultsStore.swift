import SwiftUI

/// A single time result, with the date/time it was recorded
struct Result: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let time: Double
}

/// Manages an array of `Result` in UserDefaults with @AppStorage
class ResultsStore: ObservableObject {
    // The raw data stored in UserDefaults; we’ll encode/decode JSON
    @AppStorage("results") private var storedResultsData: Data = Data()
    
    // Our in-memory array of results
    @Published var results: [Result] = []
    
    init() {
        loadResults()
    }
    
    /// Adds a new recorded result
    func addResult(time: Double) {
        let newResult = Result(timestamp: Date(), time: time)
        results.append(newResult)
        saveResults()
    }
    
    /// Removes all stored results
    func resetAll() {
        results.removeAll()
        saveResults()
    }
    
    // MARK: - Private Helpers
    
    private func loadResults() {
        guard !storedResultsData.isEmpty else {
            // No saved data yet
            results = []
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([Result].self, from: storedResultsData)
            results = decoded
        } catch {
            print("Error decoding stored results: \(error)")
            results = []
        }
    }
    
    private func saveResults() {
        do {
            let encoded = try JSONEncoder().encode(results)
            storedResultsData = encoded
        } catch {
            print("Error encoding results: \(error)")
        }
    }
}
