require_relative 'board'
require 'colorize'

class MineSweeper
  attr_reader :board

  def initialize(board_size = 10, num_mines = board_size)
    @board        = Board.new(board_size, num_mines)
    @time_started = Time.now
  end

  def render_vue
    print 'Minesweeperb'
    puts " — 🧨 #{board.num_mines} ⏳ #{(Time.now - @time_started).floor} sec.\n\n"
    print_col_header
    @board.vue.each_with_index do |row, index|
      print_row_header(index)
      row.each { |tile| print tile }
      puts
    end
  end

  def print_col_header
    # print '   '
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
      print (' ' + index.to_s.black).on_green + ' '
    else
      print (index.to_s.black).on_green + ' '
    end
  end

  def render_model
    print_col_header
    @board.model.each_with_index do |row, index|
      print_row_header(index)
      row.each { |square| print square.content }
      puts
    end
  end

  def play
    position = nil
    until position && mined?(position)
      system('clear')
      render_vue
      render_model
      terminate_if_win

      position = position_input
      reveal(position)
    end

    game_over(position)
  end

  def process_user_input(position)
    # if this tile has stats
    if @board.model[position[0]][position[1]].is_adjacent_mine?
      reveal(position)
    # if this tile is mined
    elsif @board.model[position[0]][position[1]].mined?
      game_over(position)
    # if this tile is empty
    else
      reveal(position)
      reveal_around_blank(position)
    end
  end

  def terminate_if_win
    if @board.num_revealed == ((@board.board_size**2) - @board.num_mines)
      puts "\nYou win! ✌️".green
      exit
    end
  end

  def game_over(position)
    @board.model.each do |row|
      row.each do |e|
        reveal(e.coordinates) if e.mined?
      end
    end

    system('clear')
    mark_losing_position(position)
    render_vue
    puts "\nGame over.".red
    exit
  end

  def mark_losing_position(position)
    row, col = position
    @board.vue[row][col] = @board.model[row][col].content.on_red
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
    @board.model.length - 1
  end

  def mined?(position)
    row, col = position
    @board.model[row][col].mined?
  end

  def revealed?(position)
    row, col = position
    @board.model[row][col].revealed
  end

  def reveal(position)
    row, col = position
    @board.num_revealed += 1
    @board.model[row][col].reveal_tile
    @board.vue[row][col] = @board.model[row][col].content
  end

  def reveal_around_blank(center)
    queue = []
    queue << center

    until queue.empty?
      coord = queue.shift
      deltas = [
        [-1, -1], [-1, 0], [-1, 1],
        [ 0, -1],          [ 0, 1],
        [ 1, -1], [ 1, 0], [ 1, 1],
      ]

      deltas.each do |delta|
        row = (coord[0] + delta[0])
        pos = (coord[1] + delta[1])

        unless row < 0 || row > @board.board_size - 1 || pos < 0 || pos > @board.board_size - 1
          if @board.model[row][pos].is_adjacent_mine? &&
             !@board.model[row][pos].revealed?
            reveal([row, pos])
          elsif @board.model[row][pos].empty? &&
                !@board.model[row][pos].is_adjacent_mine? &&
                !@board.model[row][pos].revealed?
            queue << [row, pos]
            reveal([row, pos])
          end
        end
      end
    end
  end
end

ms = MineSweeper.new
ms.play
