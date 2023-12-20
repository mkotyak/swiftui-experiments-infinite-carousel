import SwiftUI

struct HomeView: View {
    @State private var currentPage: UUID = .init()
    @State private var fakedPages: [Page] = []

    private var defaultPages: [Page] = [.firstPage, .secondPage, .thirdPage]

    var body: some View {
        VStack {
            titleView
            carouselView
        }
        .onAppear {
            guard fakedPages.isEmpty else {
                return
            }

            currentPage = defaultPages[0].id
            fakedPages = [.thirdPage] + defaultPages + [.firstPage]
        }
    }

    private var titleView: some View {
        Text("Infinite Carousel")
            .font(.title)
            .fontWeight(.bold)
    }

    private var carouselView: some View {
        TabView(selection: $currentPage) {
            ForEach(fakedPages) { page in
                RoundedRectangle(cornerRadius: 20)
                    .fill(page.color.gradient)
                    .padding(.horizontal, 20)
                    .tag(page.id)
                    .onDisappear {
                        if currentPage == fakedPages.first?.id {
                            currentPage = fakedPages[3].id
                        } else if currentPage == fakedPages.last?.id {
                            currentPage = fakedPages[1].id
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
            .padding(.bottom, 16)
        }
    }

    private func originalIndex(of pageID: UUID) -> Int {
        defaultPages.firstIndex { page in
            page.id == pageID
        } ?? 0
    }
}
