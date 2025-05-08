import SwiftUI

struct Card: Identifiable {
    let id: Int
    let emoji: String
    var isFlipped: Bool = false
    var isMatched: Bool = false  // Track if the card is matched
}

struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            if card.isFlipped {
                Text(card.emoji)
                    .font(.largeTitle)
                    .frame(width: 100, height: 140)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
            } else {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 140)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1) // White border
                    )
                    .shadow(radius: 5)
            }
        }
    }
}
