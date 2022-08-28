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
  attr_reader :squares

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def [](key)
    squares[key]
  end

  def []=(key, new_marker)
    squares[key].marker = new_marker
  end

  def display
    start_key = 1
    end_key = 3
    # output board as string over 5 lines
    loop do
      puts squares.fetch_values(start_key, end_key - 1, end_key).join(' | ')
      puts '- + - + -' unless end_key == 9
      start_key += 3
      end_key += 3
      break if end_key > 9
    end
  end

  def full?
    !squares.values.any? { |square| !square.marked? }
  end

  def empty_spaces
    squares.select { |_, square| !square.marked? }.keys
  end

  def find_winning_marker(player, computer)
    WINNING_OUTCOMES.each do |arr|
      return player.mark if arr.all? { |key| squares[key].marker == player.mark }
      return computer.mark if arr.all? { |key| squares[key].marker == computer.mark }
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(mark=INITIAL_MARKER)
    @marker = mark
  end

  def marked?
    marker != INITIAL_MARKER
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
      puts "Enter next move (available squares are #{board.empty_spaces.join(', ')}): "
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
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :player, :computer
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @player = Human.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
    @current_player = nil
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

    winning_marker = board.find_winning_marker(player, computer)
    if winning_marker
      puts "You won!" if winning_marker == HUMAN_MARKER
      puts "Sorry, you lost." if winning_marker == COMPUTER_MARKER
    else 
      puts "It's a tie."
    end
  end

  def display_goodbye_message
    puts "Thank for you playing!"
  end

  def current_player_moves
    current_player.play(board)
  end

  def someone_won?
    !!board.find_winning_marker(player, computer)
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
    board.reset
  end

  def human_player?
    current_player.class == player.class
  end

  def play
    clear
    display_welcome_message

    loop do
      self.current_player = player
      loop do
        display_board if human_player?
        current_player_moves
        break if someone_won? || board.full?
        self.current_player = current_player == player ? computer : player
      end
      display_result
      
      break unless play_again?
      reset
    end
    
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
