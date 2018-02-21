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

    init(suit:Suit, rank:Rank) {
        self.suit = suit;
        self.rank = rank;
        self.hashValue = suit.hashValue | (rank.hashValue << 16)
    }

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    var description : String {
        var str: String = ""
        switch suit {
        case Suit.Spades:
            str += "♠️"
            break
        case Suit.Hearts:
            str += "♥️"
            break
        case Suit.Clubs:
            str += "♣️"
            break
        case Suit.Diamonds:
            str += "♦️"
            break
        }
        switch rank {
        case Rank.Ace:
            str += "A"
            break
        case Rank.King:
            str += "K"
            break
        case Rank.Queen:
            str += "Q"
            break
        case Rank.Jack:
            str += "J"
            break
        case Rank.c10:
            str += "10"
            break
        case Rank.c9:
            str += "9"
            break
        case Rank.c8:
            str += "8"
            break
        case Rank.c7:
            str += "7"
            break
        case Rank.c6:
            str += "6"
            break
        case Rank.c5:
            str += "5"
            break
        case Rank.c4:
            str += "4"
            break
        case Rank.c3:
            str += "3"
            break
        case Rank.c2:
            str += "2"
            break
        }
        return str;
    }
}
class CardDeck {
    static func getDeck() -> Set<Card> {
        var cards:Set<Card> = []
        for r in [
            Rank.c2,
            Rank.c3,
            Rank.c4,
            Rank.c5,
            Rank.c6,
            Rank.c7,
            Rank.c8,
            Rank.c9,
            Rank.c10,
            Rank.Jack,
            Rank.Queen,
            Rank.King,
            Rank.Ace
        ] {
            for i in [Suit.Spades, Suit.Hearts, Suit.Diamonds, Suit.Clubs] {
                cards.insert(Card(suit:i, rank:r))
            }
        }
        return cards;
    }
}
