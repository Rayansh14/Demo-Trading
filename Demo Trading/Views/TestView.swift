import SwiftUI

struct TestView: View {
    
    @State var isEditing = false
    @State var searchText = ""
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        VStack {
            SearchBar(placeholderText: "Search...", searchText: $searchText, isEditing: $isEditing)
            List(data.stockQuotes.filter({ searchText.isEmpty ? true : $0.symbol.contains(searchText) })) { quote in
                Text(quote.symbol)
            }
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
