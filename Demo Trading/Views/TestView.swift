import SwiftUI

struct TestView: View {
    
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            Button(action: {showSheet = true}) {
                Text("click me")
            }
        }
        .sheet(isPresented: $showSheet) {
            Text("showing sheet")
        }
    }
}
