=begin
Recreating the rock, paper, scissors program from RB101 using object oriented
programming principles

Problem Description
Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

Nouns: player, move, rule
Verbs: choose, compare

Player
 - choose
Move
Rule

- compare

=end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts 'Enter your name: '
      n = gets.chomp
      break unless n.empty?
      puts 'Invalid name, must enter a value.'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    return true if rock? && other_move.scissors?
    return true if scissors? && other_move.paper?
    return true if paper? && other_move.rock?
    false
  end

  def <(other_move)
    return true if rock? && other_move.paper?
    return true if scissors? && other_move.rock?
    return true if paper? && other_move.scissors?
    false
  end

  def to_s
    @value
  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# Game orchestration enginer
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to the Rock, Paper, Scissors game!'
  end

  def display_goodbye_message
    puts "Thank's for playing!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
    elsif human.move < computer.move
      puts "#{computer.name} won."
      computer.score += 1
    else
      puts "It's a tie."
    end
  end

  def display_score
    puts "Current Scores"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_series_winner
    if human.score > computer.score
      puts "#{human.name} wins this round of games!"
    else
      puts "#{computer.name} wins this round."
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts 'Sorry, must be y or n'
    end

    answer.downcase == 'y'
  end

  def play
    display_welcome_message

    winning_score = 10
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score
      # break unless play_again?
      break if human.score == winning_score || computer.score == winning_score
    end

    display_series_winner
    display_goodbye_message
  end
end

RPSGame.new.play
