import SwiftUI


struct TestView: View {
    var body: some View {
        VStack {
            
            if #available(iOS 15.0, *) {
                Image(systemName: "text.badge.plus")
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(.red, .green, .blue)
                    .font(.system(size: 350))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


struct TestViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            TestView()
        }
    }
}
