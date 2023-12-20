import SwiftUI

struct Page: Identifiable, Hashable {
    var id: UUID = .init()
    let color: Color
    
    static var firstPage: Self {
        .init(color: .red)
    }
    
    static var secondPage: Self {
        .init(color: .green)
    }
    
    static var thirdPage: Self {
        .init(color: .blue)
    }
}
