import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let maxRating: Int = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(systemName: self.starType(at: index))
                    .foregroundColor(.yellow)
            }
        }
    }

    private func starType(at index: Int) -> String {
        if rating >= Double(index + 1) {
            return "star.fill"
        } else if rating > Double(index) {
            return "star.lefthalf.fill"
        } else {
            return "star"
        }
    }
}
