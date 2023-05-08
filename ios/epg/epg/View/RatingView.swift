import SwiftUI

struct RatingView: View {

    @Binding var rating: Int?

    private func starType(index: Int) -> String {
        if let rating = self.rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
    }

    var body: some View {
        HStack {
            ForEach(1...10, id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundColor(.orange)
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}


struct RatingView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(reducer: appReducer, state: AppState())

        return RatingView(rating: .constant(5))
    }
}
