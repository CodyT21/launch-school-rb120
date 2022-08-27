=begin
Tic Tac Toe game programmed using object oriented
programming principles.

# Description
Tic Tac Toe is a 2-player board game played on a 3x3 grid. 
Players take turns marking a square. The first player to 
mark 3 squares in a row wins.

Nouns: board, player, square, grid
Verbs: play, mark

Board
Square
Player
- mark
- play

=end

class Board
  def initialize

  end
end

class Square
  def initialize
  end
end

class Player
  def initialize
  end

  def mark

  end

  def play

  end
end

class TTTGame
  attr_reader :board
  
  def initialize
    @board = Board.new
  end

  def display_welcome_message
    puts "Welcome to the Tic Tac Toe game!"
  end

  def display_board
    puts "Current Board:"
    board.display
  end

  def display_result
    puts "Final result:"
    board.display

    if player_wins?(player, computer)
      puts "You won!"
    elsif board.full? && !someone_won?
      puts "It's a tie."
    else
      puts "Sorry, you lost."
    end
  end

  def display_goodbye_message
    puts "Thank for you playing!"
  end

  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
