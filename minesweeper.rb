require_relative 'board'

class MineSweeper
  attr_reader :board

  def initialize(grid_size, num_mines = grid_size)
    @board = Board.new(grid_size, num_mines)
  end

  def render
    @board.minefield.each do |row|
      row.each { |square| print square }
      puts
    end
  end
end

ms = MineSweeper.new(5)
ms.render