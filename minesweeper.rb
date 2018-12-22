require_relative 'board'
require 'colorize'

class MineSweeper
  attr_reader :board

  def initialize(board_size = 10, num_mines = board_size)
    @board        = Board.new(board_size, num_mines)
    @time_started = Time.now
  end

  def render_grid_player
    print "Minesweeperb".green.on_black
    puts " — 🧨 #{board.num_mines} ⏳ #{(Time.now - @time_started).floor} sec.\n".green.on_black
    print_col_header

    @board.grid_player.each_with_index do |row, index|
      print_row_header(index)
      row.each { |tile| print tile }
      puts
    end
  end

  def print_col_header
    print '   '
    (0..board_size).each do |num|
      print '  ' if num.zero?
      if num < 10
        print "  #{num.to_s.black}".on_green
      else
        print " #{num.to_s.black}".on_green

      end
    end
    puts
  end

  def print_row_header(index)
    if index < 10
      print '   ' + (' ' + index.to_s.black).on_green + ' '
    else
      print '   ' + (index.to_s.black).on_green + ' '
    end
  end

  def render_grid_mines
    print_col_header

    @board.grid_mines.each_with_index do |row, index|
      print_row_header(index)
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
    if @board.num_revealed_tiles == ((@board.board_size**2) - @board.num_mines)
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

    system('clear')
    mark_losing_position(position)
    render_grid_player
    puts "\nYou stepped on it! Game over".red.on_black
    puts && exit
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
    @board.num_revealed_tiles += 1
    @board.grid_mines[row][col].reveal_tile
    @board.grid_player[row][col] = @board.grid_mines[row][col].content
  end
end

ms = MineSweeper.new(5)
ms.play
