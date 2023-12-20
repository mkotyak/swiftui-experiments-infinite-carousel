import SwiftUI

/// More complex implementation with using GeometryReader and OffsetReader

struct HomeView_Option2: View {
    @State private var currentPage: UUID = .init()
    @State var extendedPages: [Page] = []

    private var defaultPages: [Page] = [.firstPage, .secondPage, .thirdPage]

    var body: some View {
        VStack {
            titleView
            carouselView
        }
        .onAppear {
            guard extendedPages.isEmpty else {
                return
            }

            currentPage = defaultPages[0].id
            extendedPages = [.thirdPage] + defaultPages + [.firstPage]
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
                ForEach(extendedPages) { page in
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
                                if extendedPages.indices.contains(extendedPages.count - 1) {
                                    currentPage = extendedPages[extendedPages.count - 1].id
                                }
                            }

                            if -pageProgress > CGFloat(extendedPages.count - 1) {
                                // Movig to the first page
                                // Which is actually the Last Duplicated
                                if extendedPages.indices.contains(1) {
                                    currentPage = extendedPages[1].id
                                }
                            }
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                PageControlView(
                    totalPages: defaultPages.count,
                    currentPage: originalIndex(of: currentPage)
                )
                .padding(.bottom, 15)
            }
        }
    }

    private func fakeIndex(of page: Page) -> Int {
        extendedPages.firstIndex(of: page) ?? 0
    }

    private func originalIndex(of pageID: UUID) -> Int {
        defaultPages.firstIndex { page in
            page.id == pageID
        } ?? 0
    }
}
