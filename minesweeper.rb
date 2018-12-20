require_relative 'board'
require 'colorize'

class MineSweeper
  attr_reader :board

  def initialize(grid_size, num_mines = grid_size)
    @board = Board.new(grid_size, num_mines)
  end

  def render_minefield
    @board.minefield.each do |row|
      row.each { |square| print square.content }
      puts
    end
  end

  def play
    position = nil
    until position && mined?(position)
      system('clear')
      render_minefield

      position = position_input
      reveal(position)
    end
    game_over
  end

  def game_over
    puts '💥 You stepped on a mine! Game over'.red
    exit
  end

  def position_input
    puts  "\nPlease enter a position on the board (e.g., '0,2')"
    print '> '

    position = gets.chomp.split(',').map(&:to_i)
    until position && valid_input?(position)
      puts "ERROR! Enter two comma separated numbers, each between 0 and #{board_size}".red
      print '> '
      position = gets.chomp.split(',').map(&:to_i)
    end
    position
  end

  def valid_input?(input)
    input.length == 2 &&
      input.all? { |el| el.is_a? Integer } &&
      input.all? { |el| el.between?(0, board_size) }
  end

  def board_size
    @board.minefield.length - 1
  end

  def mined?(position)
    row, col = position
    @board.minefield[row][col].mined?
  end
end

ms = MineSweeper.new(5)
ms.play
