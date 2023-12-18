import SwiftUI

struct MainView: View {
    @State var isSheetPresented: Bool = false

    var body: some View {
        Text("Main view")
            .sheet(isPresented: $isSheetPresented, content: {
                HomeView()
            })
            .onAppear {
                isSheetPresented = true
            }
    }
}
