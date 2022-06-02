import SwiftUI
//
//
//var basicGuide: Guide {
//    let guide = Guide()
//    guide.title = "Stock Market Basics"
//    guide.imageName = "stock-market-animation"
//    guide.views = [
////        ScrollView{Text("View zfdb 1")}.self, ScrollView{Text("View ch 2")}.self
//    ]
//    return guide
//}
//
//
//
struct TestView: View {
    var body: some View {
        Rectangle()
            .padding()
            .foregroundColor(.green)
            .cornerRadius(200, corners: [.topRight, .bottomRight])
    }
}

struct TestView_Preview: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
