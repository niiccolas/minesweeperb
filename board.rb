require 'colorize'

class Board
  attr_reader :minefield

  def initialize(grid_size, num_mines)
    @minefield = Array.new(grid_size) { Array.new(grid_size) { '*' } }
    seed_mines(num_mines)
  end

  def seed_mines(num_mines)
    num_mines.times do
      x, y = random_position
      loop do
        empty_position?(x, y) ? break : (x, y = random_position)
      end

      @minefield[x][y] = 'B'.red
    end
  end

  def random_position
    [rand(@minefield.length), rand(@minefield.length)]
  end

  def empty_position?(row, col)
    @minefield[row][col] == '*'
  end
end
