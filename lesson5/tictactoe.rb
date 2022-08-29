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

  def find_winning_marker(player, comp)
    WINNING_OUTCOMES.each do |arr|
      return player.mark if arr.all? { |k| squares[k].marker == player.mark }
      return comp.mark if arr.all? { |k| squares[k].marker == comp.mark }
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
  attr_accessor :score, :name

  def initialize(mark, score=0)
    set_name
    @mark = mark
    @score = score
  end

  def mark_board(choice, board)
    board[choice].marker = mark
  end
end

class Human < Player
  def play(board)
    choice = nil
    loop do
      puts "Choose a position to place a mark: #{joinor(board.empty_spaces)}"
      choice = gets.chomp.to_i
      break if board.empty_spaces.include?(choice)
      puts "Invalid move. Only choose from the available squares."
    end
    mark_board(choice, board)
  end

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

  private

  def joinor(nums, separator=', ', last_separator='or')
    case nums.length
    when 0 then ''
    when 1 then nums.first.to_s
    when 2 then nums.join(" #{last_separator} ")
    else
      join_str(nums, separator, last_separator)
    end
  end

  def join_str(nums, separator, last_separator)
    str = ''
    nums.each_with_index do |num, index|
      str += if index < nums.length - 1
               num.to_s + separator
             else
               "#{last_separator} #{num}"
             end
    end
    str
  end
end

class Computer < Player
  def play(board)
    square = get_square(board)
    mark_board(square, board)
  end

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  private

  def find_at_risk_squares(line, board, marker=mark)
    return unless board.squares.values_at(*line).count(marker) == 2
    at_risk_squares = board.select do |key, square|
      line.include?(key) && square.marker == ' '
    end
    at_risk_squares.keys.first
  end

  def offensive_move(board)
    Board::WINNING_OUTCOMES.each do |arr|
      square = find_at_risk_squares(arr, board, mark)
      return square if square
    end
    nil
  end

  def defensive_move(board)
    Board::WINNING_OUTCOMES.each do |arr|
      square = find_at_risk_squares(arr, board, mark)
      return square if square
    end
    nil
  end

  def get_square(board)
    square = offensive_move(board)
    square = defensive_move(board) if !square
    if !square
      square = if board.empty_spaces.include?(5)
                 5
               else
                 board.empty_spaces.sample
               end
    end
    square
  end
end

class TTTGame
  WINNING_SCORE = 5

  attr_reader :board, :player, :computer
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @player = Human.new(choose_marker)
    @computer = Computer.new(player.mark == 'X' ? 'O' : 'X')
    @current_player = nil
  end

  def play
    clear
    display_welcome_message

    until player.score == WINNING_SCORE || computer.score == WINNING_SCORE
      self.current_player = player
      main_game
    end
    display_score(final_score: true)
    display_goodbye_message
  end

  private

  def main_game
    display_score
    loop do
      display_board if human_player?
      current_player_moves
      break if someone_won? || board.full?
      self.current_player = current_player == player ? computer : player
    end
    update_score
    display_result
    reset
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
      puts "You won!" if winning_marker == player.mark
      puts "Sorry, you lost." if winning_marker == computer.mark
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

  def update_score
    winning_marker = board.find_winning_marker(player, computer)
    winning_marker == player.mark ? player.score += 1 : computer.score += 1
  end

  def display_score(final_score: false)
    if final_score
      puts "Final Scores"
    else
      puts "Current Scores"
    end
    puts "#{player.name}: #{player.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def choose_marker
    marker_choice = nil
    loop do
      puts "Which marker would you like to be: 'X' or 'O'"
      marker_choice = gets.chomp.upcase!
      break if %w(X O).include?(marker_choice)
      puts "Invalid entry. Only input X or O."
    end
    marker_choice
  end
end

game = TTTGame.new
game.play
