import SwiftUI

struct TestView: View {
    
    @State private var users = ["Paul", "Taylor", "Adele"]

    var body: some View {
        NavigationView {
            VStack {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onDelete(perform: delete)
            }
        }
    }

    func delete(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
