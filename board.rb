require_relative 'tile'
require 'colorize'

class Board
  attr_reader   :model, :vue, :num_mines, :board_size
  attr_accessor :num_revealed

  def initialize(grid_size, num_mines)
    @num_revealed = 0
    @num_mines    = num_mines
    @board_size   = grid_size
    @vue          = Array.new(grid_size) { Array.new(grid_size) { ' * ' } }
    @model        = Array.new(grid_size) { Array.new(grid_size) { Tile.new } }

    plant_mines(num_mines)
    count_adjacent_mines
    save_coordinates
  end

  def plant_mines(num_mines)
    num_mines.times do
      x, y = random_position
      loop do
        empty_position?(x, y) ? break : (x, y = random_position)
      end

      @model[x][y].plant_mine
    end
  end

  def random_position
    [rand(@model.length), rand(@model.length)]
  end

  def empty_position?(row, col)
    @model[row][col].empty?
  end

  def count_adjacent_mines
    model.each_with_index do |row, row_index|
      row.each_index do |col_index|
        check_neighbours(row_index, col_index)
      end
    end
  end

  def check_neighbours(row, col)
    if model[row][col].content == ' 💩'
      (row - 1..row + 1).each do |row_index|
        # Skip row indices that are out of the board
        next if row_index < 0 || row_index > board_size - 1

        (col - 1..col + 1).each do |col_index|
          # Skip column indices that are out of the board
          next if col_index < 0 ||
                  col_index > board_size - 1 ||
                  # Skip current position
                  (row_index == row && col_index == col)

          unless model[row_index][col_index].content == ' 💩'
            model[row_index][col_index].count_adjacent_mine
          end
        end
      end
    end
  end

  def save_coordinates
    model.each_with_index do |row, row_index|
      row.each_index do |col_index|
        @model[row_index][col_index].coordinates = [row_index, col_index]
      end
    end
  end
end
