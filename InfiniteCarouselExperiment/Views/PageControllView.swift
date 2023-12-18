import SwiftUI

struct PageControllView: UIViewRepresentable {
    var totalPages: Int
    var currentPage: Int

    func makeUIView(context: Context) -> UIPageControl {
        let controll = UIPageControl()
        controll.numberOfPages = totalPages
        controll.currentPage = currentPage
        controll.backgroundStyle = .minimal
        controll.allowsContinuousInteraction = false

        return controll
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = totalPages
        uiView.currentPage = currentPage
    }
}
