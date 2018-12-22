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
    @grid_mines[row][col].empty?
  end

  def count_adjacent_mines
    grid_mines.each_with_index do |row, row_index|
      row.each_index do |col_index|
        check_neighbours(row_index, col_index)
      end
    end
  end

  def check_neighbours(row, col)
    if grid_mines[row][col].content == '💩'
      (row - 1..row + 1).each do |row_index|
        # Skip row indices that are out of the board
        next if row_index < 0 || row_index > board_size - 1

        (col - 1..col + 1).each do |col_index|
          # Skip column indices that are out of the board
          next if col_index < 0 ||
                  col_index > board_size - 1 ||
                  # Skip current position
                  (row_index == row && col_index == col)

          unless grid_mines[row_index][col_index].content == '💩'
            grid_mines[row_index][col_index].count_adjacent_mine
          end
        end
      end
    end
  end

  def save_coordinates
    grid_mines.each_with_index do |row, row_index|
      row.each_index do |col_index|
        @grid_mines[row_index][col_index].coordinates = [row_index, col_index]
      end
    end
  end
end
