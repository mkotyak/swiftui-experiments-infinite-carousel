import SwiftUI

struct HomeView: View {
    @State private var currentPage: UUID = .init()
    @State private var listOfPages: [Page] = []

    @State var fakedPages: [Page] = []

    var body: some View {
        VStack {
            titleView
            carouselView
        }
        .onAppear {
            guard fakedPages.isEmpty else {
                return
            }

            for color in [Color.yellow, Color.blue, Color.pink] {
                listOfPages.append(.init(color: color))
            }

            fakedPages.append(contentsOf: listOfPages)

            if var firstPage = listOfPages.first,
               var lastPage = listOfPages.last
            {
                currentPage = firstPage.id

                firstPage.id = .init()
                lastPage.id = .init()

                fakedPages.append(firstPage)
                fakedPages.insert(lastPage, at: 0)
            }
        }
    }

    private var titleView: some View {
        Text("Infinite Carousel")
            .font(.title)
            .fontWeight(.bold)
    }

    private var carouselView: some View {
        GeometryReader {
            let size = $0.size

            TabView(selection: $currentPage) {
                ForEach(fakedPages) { page in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(page.color.gradient)
                        .padding(.horizontal, 20)
                        .tag(page.id)

                        // Calculating Entire Page Scroll Offset
                        .offsetX(currentPage == page.id) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(fakeIndex(of: page)))

                            // Converting Page Offset into Progress
                            let pageProgress = pageOffset / size.width

                            // Infinit Carousel logic
                            if -pageProgress < 1.0 {
                                // Movig to the last page
                                // Which is actually the First Duplicated
                                if fakedPages.indices.contains(fakedPages.count - 1) {
                                    currentPage = fakedPages[fakedPages.count - 1].id
                                }
                            }

                            if -pageProgress > CGFloat(fakedPages.count - 1) {
                                // Movig to the first page
                                // Which is actually the Last Duplicated
                                if fakedPages.indices.contains(1) {
                                    currentPage = fakedPages[1].id
                                }
                            }
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                PageControllView(
                    totalPages: listOfPages.count,
                    currentPage: originalIndex(of: currentPage)
                )
                .padding(.bottom, 15)
            }
        }
    }

    private func fakeIndex(of page: Page) -> Int {
        fakedPages.firstIndex(of: page) ?? 0
    }

    private func originalIndex(of pageID: UUID) -> Int {
        listOfPages.firstIndex { page in
            page.id == pageID
        } ?? 0
    }
}
