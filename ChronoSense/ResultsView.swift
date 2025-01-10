import SwiftUI

struct ResultsView: View {
    let targetTime: Double
    let actualTime: Double
    
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
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(targetTime: 30, actualTime: 27.5)
    }
}
/*
#Preview {
    ResultsView()
}
*/
