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
  WINNING_OUTCOMES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                      [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
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

  def [](key)
    board[key]
  end

  def []=(key, new_marker)
    board[key].marker = new_marker
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
    !board.values.any? { |square| square.marker == ' ' }
  end

  def empty_spaces
    board.select { |_, square| square.marker == ' ' }.keys
  end

  def find_winner(player, computer)
    WINNING_OUTCOMES.each do |arr|
      return 1 if arr.all? { |key| board[key].marker == player.mark }
      return 2 if arr.all? { |key| board[key].marker == computer.mark }
    end
    0
  end
end

class Square
  attr_accessor :marker

  def initialize
    @marker = ' '
  end

  def to_s
    marker
  end
end

class Player
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def mark_board(choice, board)
    board[choice].marker = mark
  end
end

class Human < Player
  def play(board)
    choice = nil
    loop do
      puts "Enter next move (available squares are #{board.empty_spaces}: "
      choice = gets.chomp.to_i
      break if board.empty_spaces.include?(choice)
      puts "Invalid move. Only choose from the available squares."
    end
    mark_board(choice, board)
  end
end

class Computer < Player
  def play(board)
    choice = board.empty_spaces.sample
    mark_board(choice, board)
  end
end

class TTTGame
  attr_reader :board, :player, :computer

  def initialize
    @board = Board.new
    @player = Human.new('X')
    @computer = Computer.new('O')
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

    game_status = board.find_winner(player, computer)
    if game_status == 1
      puts "You won!"
    elsif board.full? && game_status == 0
      puts "It's a tie."
    else
      puts "Sorry, you lost."
    end
  end

  def display_goodbye_message
    puts "Thank for you playing!"
  end

  def first_player_moves
    player.play(board)
  end

  def second_player_moves
    computer.play(board)
  end

  def someone_won?
    board.find_winner(player, computer) > 0
  end

  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board.full?

      display_board
      second_player_moves
      break if someone_won? || board.full?
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
