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
end

ms = MineSweeper.new(5)
ms.play