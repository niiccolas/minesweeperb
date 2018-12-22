require_relative 'board'
require 'colorize'

class MineSweeper
  attr_reader :board

  def initialize(board_size = 10, num_mines = board_size)
    @board = Board.new(board_size, num_mines)
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
      render_grid_player
      # render_grid_mines
      terminate_if_won

      position = position_input
      reveal(position)
    end

    game_over(position)
  end

  def terminate_if_won
    if @board.num_revealed == ((@board.board_size**2) - @board.num_mines)
      puts "\nCongratulations, you won! ✌️"
      exit
    end
  end

  def game_over(position)
    @board.grid_mines.each do |row|
      row.each do |e|
        reveal(e.coordinates) if e.mined?
      end
    end

  def game_over
    puts '💥 You stepped on a mine! Game over'.red
    exit
  end

  def mark_losing_position(position)
    row, col = position
    @board.grid_player[row][col] = @board.grid_mines[row][col].content.on_red
  end

  def position_input
    puts  "\nEnter a position (e.g., '0,2')"
    print '> '

    position = gets.chomp.split(',').map(&:to_i)
    loop do
      unless valid_input?(position)
        puts "ERROR! Enter two comma separated numbers, each between 0 and #{board_size}".red
        print '> '
        position = gets.chomp.split(',').map(&:to_i)
        redo
      end

      if revealed?(position)
        puts 'Position already revealed! Try again'.red
        print '> '
        position = gets.chomp.split(',').map(&:to_i)
        redo
      else
        break
      end
    end
    position
  end

  def valid_input?(input)
    input.length == 2 &&
      input.all? { |el| el.is_a? Integer } &&
      input.all? { |el| el.between?(0, board_size) }
  end

  def board_size
    @board.grid_mines.length - 1
  end

  def mined?(position)
    row, col = position
    @board.grid_mines[row][col].mined?
  end

  def revealed?(position)
    row, col = position
    @board.grid_mines[row][col].revealed
  end

  def reveal(position)
    row, col = position
    @board.num_revealed += 1
    @board.grid_mines[row][col].reveal_tile
    @board.grid_player[row][col] = @board.grid_mines[row][col].content
  end
end

ms = MineSweeper.new(5)
ms.play
