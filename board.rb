require_relative 'tile'
require 'colorize'

class Board
  attr_reader :grid_mines, :grid_player, :num_mines, :board_size
  attr_accessor :num_revealed_tiles

  def initialize(grid_size, num_mines)
    @num_revealed_tiles = 0
    @num_mines          = num_mines
    @board_size         = grid_size
    @grid_player        = Array.new(grid_size) { Array.new(grid_size) { '* ' } }
    @grid_mines         = Array.new(grid_size) { Array.new(grid_size) { Tile.new } }

    plant_mines(num_mines)
  end

  def plant_mines(num_mines)
    num_mines.times do
      x, y = random_position
      loop do
        empty_position?(x, y) ? break : (x, y = random_position)
      end

      @minefield[x][y].plant_mine
    end
  end

  def random_position
    [rand(@minefield.length), rand(@minefield.length)]
  end

  def empty_position?(row, col)
    @minefield[row][col].empty?
  end
end
