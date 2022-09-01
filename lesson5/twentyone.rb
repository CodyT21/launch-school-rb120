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

  def hit(deck)
    card = deck.deal
    puts "Next card is: #{card}"
    hand << card
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

  def reset
    self.hand = []
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

  # could move some logic from Game class here
  def stay
  end

end

class Dealer < Participant
  def show_hand
    joinand(hand[1..-1]) + " and one unknown card."
  end

  def stay
  end
end

class Deck
  attr_accessor :cards

  # change to using Card class to represent each individual card
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

  def reset
    self.cards = {
      hearts: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace),
      diamonds: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace),
      clubs: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace),
      spades: %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
    }
  end
end

# implement in the future
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
    play = nil
    until play == 'stay' || player.busted?
      loop do
        puts "Total: #{player.total}"
        puts "Would you like to hit or stay?"
        play = gets.chomp.downcase
        break if %w(hit stay).include?(play)
        puts "Invalid entry. Only input hit or stay."
      end
      player.hit(deck) if play == 'hit'
    end
    puts "Player stays." unless player.busted?
  end

  def dealer_turn
    until dealer.total > 15 || player.busted?
      puts "Dealer hits..."
      dealer.hit(deck)
    end
    puts "Dealer stays." unless dealer.busted?
  end

  def show_result
    if player.busted?
      puts "Sorry, you busted. Dealer wins."
    elsif dealer.busted?
      puts "Dealer busted. You won!"
    else
      puts "Hand Totals"
      puts "Player Total: #{player.total}"
      puts "Dealer Total: #{dealer.total}"
      puts "You won!" if player.total > dealer.total
      puts "Sorry, you lost this round." if dealer.total > player.total
      puts "It's a tie." if player.total == dealer.total
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid entry. Only input y or n."
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    clear
    puts "Let's play again!"
    deck.reset
    player.reset
    dealer.reset
  end

  def start
    loop do
      clear
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn
      show_result
      break unless play_again?
      reset
    end
  end
end

Game.new.start