import SwiftUI

/// A single time result, with the date/time it was recorded
struct Result: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    
    /// Store both the user's chosen (target) time and the actual time
    let targetTime: Int      // e.g. 5, 10, 15, ...
    let actualTime: Double   // e.g. 5.73
    
    // If you prefer Double for targetTime, just change `Int` to `Double`.
}

/// Manages an array of `Result` in UserDefaults with @AppStorage
class ResultsStore: ObservableObject {
    @AppStorage("results") private var storedResultsData: Data = Data()
    
    @Published var results: [Result] = []
    
    init() {
        loadResults()
    }
    
    /// Adds a new recorded result
    func addResult(targetTime: Int, actualTime: Double) {
        let newResult = Result(timestamp: Date(),
                               targetTime: targetTime,
                               actualTime: actualTime)
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
