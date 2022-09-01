=begin

# Description
Twenty-One is a card game consisting of a dealer and a player,
where the participants try to get as close to 21 as possible without
going over.

Here is an overview of the game:
- Both participants are initially dealt 2 cards from a 52-card deck.
- The player takes the first turn, and can "hit" or "stay".
- If the player busts, he loses. If he stays, it's the dealer's turn.
- The dealer must hit until his cards add up to at least 17.
- If he busts, the player wins. If both player and dealer stays,
  then the highest total wins.
- If both totals are equal, then it's a tie, and nobody wins.

Nouns: card, player, dealer, participant, deck, game, total
Verbs: deal, hit, stay, busts

Player
- hit
- stay
- busted?
- total
Dealer
- hit
- stay
- busted?
- total
- deal (should this be here, or in Deck?)
Participant
Deck
- deal (should this be here, or in Dealer?)
Card
Game
- start

=end

class Participant
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def busted?
    total > 21
  end

  def total
    hand_values = []
    aces = hand.select { |card| card.include?('Ace') }
    non_ace_cards = hand.select { |card| !card.include?('Ace') }
    non_ace_cards.each do |card|
      card_value = card.split[0]
      hand_values << if card_value.match(/(Jack|Queen|King)/)
                       10
                     else
                       card.to_i
                     end
    end
    
    calculate_ace_values!(aces, hand_values)
    hand_values.sum
  end
  
  def calculate_ace_values!(aces, card_values)
    aces.each do
      card_values << if aces.length == 1
                       card_values.sum < 11 ? 11 : 1
                     else
                       card_values.sum < 11 - aces.length ? 11 : 1
                     end
    end
  end

  # probably should move this method out of class
  def joinand(elems, separator=', ', last_separator='and')
    case elems.length
    when 0 then ''
    when 1 then elems.first.to_s
    when 2 then elems.join(" #{last_separator} ")
    else
      str = ''
      elems.each_with_index do |num, index|
        str << if index < elems.length - 1
                 num.to_s + separator
               else
                 "#{last_separator} #{num}"
               end
      end
      str
    end
  end
end

class Player < Participant
  def show_hand
    joinand(hand)
  end
  
  def hit
  end

  def stay
  end
end

class Dealer < Participant
  def show_hand
    joinand(hand[1..-1]) + " and one unknown card."
  end

  def hit
  end

  def stay
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = {
      hearts: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace),
      diamonds: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace),
      clubs: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace),
      spades: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
    }
  end

  def deal
    suit = nil
    until suit
      suit = cards.keys.sample
      if cards[suit].empty?
        suit = nil
      end
    end
    card = cards[suit].sample
    card_index = cards[suit].index(card)
    cards[suit].delete_at(card_index)
    "#{card} of #{suit.to_s.capitalize}"
  end
end

class Card
  def initialize
  end
end

class Game
  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def deal_cards
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def show_initial_cards
    puts "Player has: #{player.show_hand}"
    puts "Dealer has: #{dealer.show_hand}" 
  end

  def player_turn
    player.play
  end

  def dealer_turn
    dealer.play
  end

  def show_results
    puts "Final Scores"
    puts "Player total: #{player.total}"
    puts "Dealer total: #{dealer.total}"
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start