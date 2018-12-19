require_relative 'board'

class MineSweeper
  attr_reader :board

  def initialize(grid_size, num_mines = grid_size)
    @board = Board.new(grid_size, num_mines)
  end
end
