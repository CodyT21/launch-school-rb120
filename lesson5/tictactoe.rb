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
  attr_reader :board

  def initialize
    @board = {
      1 => Square.new,
      2 => Square.new,
      3 => Square.new,
      4 => Square.new,
      5 => Square.new,
      6 => Square.new,
      7 => Square.new,
      8 => Square.new,
      9 => Square.new
    }
  end

  def display
    start_key = 1
    end_key = 3
    # output board as string over 5 lines
    loop do
      puts board.fetch_values(start_key, end_key - 1, end_key).join(' | ')
      puts '- + - + -' unless end_key == 9
      start_key += 3
      end_key += 3
      break if end_key > 9
    end
  end

  def full?
    !board.values.any?(' ')
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
      break if someone_won? || board.full?

      second_player_moves
      break if someone_won? || board.full?
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
