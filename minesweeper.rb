require_relative 'board'

class MineSweeper
  attr_reader :board

  def initialize(grid_size, num_mines = grid_size)
    @board = Board.new(grid_size, num_mines)
  end

  def render_minefield
    @board.minefield.each do |row|
      row.each { |square| print square }
      puts
    end
  end

  def play
    system('clear')
    render_minefield

    position_input
  end

  def game_over
    puts 'Game over!'.yellow
    exit
  end

  def position_input
    puts  "\nPlease enter a position on the board (e.g., '0,2')"
    print '> '

    until valid_input?(gets.chomp.split(',').map(&:to_i))
      puts 'Error! Enter two numbers, separated by a comma'.red
      print '> '
    end
  end

  def valid_input?(input)
    input.length == 2 && input.all? { |el| el.is_a? Integer }
  end

  def mined?(input)
    row, col = [input]
    board[row, col] == 'B'
  end
end

ms = MineSweeper.new(5)
ms.play