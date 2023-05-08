import SwiftUI

struct URLImage: View {
    let url: String

    init(url: String) {
        self.url = url
    }

    var body: some View {
        return VStack {
            Image("placeholder").resizable()
        }
    }
}
