import SwiftUI

struct ContentView: View {
    @State private var showingSizeOption = false
    @State private var selectedSize: Int = 3
    @State private var cards: [Card] = []
    @State private var flippedCards: [Card] = [] // Track currently flipped cards

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let emojis = ["🍎", "🍊", "🍇", "🍌", "🍉", "🥑", "🍒", "🥭", "🍍", "🍓","🦀","🤘","🦾"] // Emoji pool
    
    // Computed property to check if all cards are matched
    private var allCardsMatched: Bool {
        cards.allSatisfy { $0.isMatched }
    }


    var body: some View {
        VStack(spacing: 10) {
            // Title for the Memory Game
                        Text("Memory Game")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink.gradient) // Same color as HStack
                            //.cornerRadius(10)
            
            HStack {
                Button("Choose Size") {
                    withAnimation {
                        showingSizeOption.toggle()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
                .foregroundColor(Color.purple)
                .cornerRadius(16)
                .overlay(
                    VStack {
                        if showingSizeOption {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach([3, 6, 12], id: \.self) { size in
                                    Button(action: {
                                        selectedSize = size
                                        generateCards() // Regenerate cards on size change
                                        showingSizeOption = false
                                    }) {
                                        Text("\(size) Pairs")
                                            //.padding()
                                            .background(selectedSize == size ? Color.gray.opacity(0.3) : Color.clear)
                                            .cornerRadius(5)
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    .offset(y: 5)
                )
                .padding(.vertical, 5)
                
                Spacer()
                    .frame(width: 25)
                
                Button("Reset") {
                    generateCards() // Reset cards on button click
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
                .foregroundColor(Color.purple)
                .cornerRadius(16)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.pink.gradient)
            
            // Show "Congratulations" message if all cards are matched
                        if allCardsMatched {
                            Spacer(minLength:20)
                            Text("Congratulations! You finished the game!")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }


            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cards) { card in
                        // Conditionally render card view to prevent shifting
                        CardView(card: card)
                            .opacity(card.isMatched ? 0 : 1) // Hide matched cards but keep their space
                            .onTapGesture {
                                flipCard(card: card) // Flip card on tap
                            }
                        
//                        if !card.isMatched { // Only show cards that are not matched
//                            CardView(card: card)
//                                .onTapGesture {
//                                    flipCard(card: card) // Flip card on tap
//                                }
//                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.top)
            }
        }
        .background(Color.pink.gradient)
        .onAppear {
            generateCards() // Generate initial cards on view load
        }
    }

    // Generate pairs of cards with unique emojis
    private func generateCards() {
        let pairedEmojis = (emojis.prefix(selectedSize) + emojis.prefix(selectedSize)).shuffled()
        cards = (0..<(selectedSize * 2)).map { index in
            Card(id: index, emoji: pairedEmojis[index])
        }
        flippedCards.removeAll() // Clear flipped cards on new game
    }

    // Flip card and check for a match if two cards are flipped
    private func flipCard(card: Card) {
        if flippedCards.count < 2, let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFlipped.toggle() // Flip the selected card
            flippedCards.append(cards[index]) // Add to flipped cards
            
            if flippedCards.count == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    checkForMatch() // Check match immediately after second card flip
                }
               
            }
        }
    }

    // Check if the two flipped cards match
    private func checkForMatch() {
        if flippedCards.count == 2 {
            if flippedCards[0].emoji == flippedCards[1].emoji {
                //DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    // Cards match, mark both as matched
                    if let firstIndex = cards.firstIndex(where: { $0.id == flippedCards[0].id }),
                       let secondIndex = cards.firstIndex(where: { $0.id == flippedCards[1].id }) {
                        cards[firstIndex].isMatched = true
                        cards[secondIndex].isMatched = true
                    }
                //}
                
            } else {
                //DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    print("Dispatch Called")
                    // No match, flip both cards back immediately
                    for flippedCard in flippedCards {
                        if let index = cards.firstIndex(where: { $0.id == flippedCard.id }) {
                            cards[index].isFlipped = false
                        }
                    //}
                    //objectWillChange.send()
                }

            }
            flippedCards.removeAll() // Clear flipped cards after check
        }
    }
}

#Preview {
    ContentView()
}
