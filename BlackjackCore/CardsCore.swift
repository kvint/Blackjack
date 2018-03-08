import Foundation

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
}
enum Rank {
    case c2
    case c3
    case c4
    case c5
    case c6
    case c7
    case c8
    case c9
    case c10
    case Jack
    case Queen
    case King
    case Ace
}

struct Card: CustomStringConvertible, Hashable {
    var suit: Suit
    var rank: Rank

    private(set) var hashValue: Int = 0

    init(_ rank:Rank, _ suit:Suit = Suit.Spades) {
        self.rank = rank;
        self.suit = suit;
        self.hashValue = suit.hashValue | (rank.hashValue << 16)
    }

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    var description : String {
        let suits = [
            Suit.Spades: "♠️",
            Suit.Hearts: "♥️",
            Suit.Clubs: "♣️",
            Suit.Diamonds: "♦️"
        ]
        let ranks = [
            Rank.Ace: "A",
            Rank.King: "K",
            Rank.Queen: "Q",
            Rank.Jack: "J",
            Rank.c10: "10",
            Rank.c9: "9",
            Rank.c8: "8",
            Rank.c7: "7",
            Rank.c6: "6",
            Rank.c5: "5",
            Rank.c4: "4",
            Rank.c3: "3",
            Rank.c2: "2"
        ]

        return "\(suits[self.suit]!) \(ranks[self.rank]!)";
    }
}
class CardDeck {
    static func getDeck() -> Set<Card> {
        var cards:Set<Card> = []
        for rank in [
            Rank.c2, Rank.c3, Rank.c4, Rank.c5,
            Rank.c6, Rank.c7, Rank.c8, Rank.c9,
            Rank.c10, Rank.Jack, Rank.Queen, Rank.King,
            Rank.Ace
        ] {
            for suit in [Suit.Spades, Suit.Hearts, Suit.Diamonds, Suit.Clubs] {
                cards.insert(Card(rank, suit))
            }
        }
        return cards;
    }
}
