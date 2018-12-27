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
    puts " — 🧨 #{board.num_mines} ⏳ #{(Time.now - @time_started).floor} sec\n\n"
    print_col_header
    @board.vue.each_with_index do |row, index|
      print_row_header(index)
      row.each { |tile| print tile }
      puts
    end
  end

  def print_col_header
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
      print index.to_s.black.on_green + ' '
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
    until position && mined?(position) && !flagged?(position) #! faire distingo entre position & command
      system('clear')
      render_vue
      # render_model
      terminate_if_win

      position = position_input

      if flagging?(position)
        flag(position)
      else
        process_user_input(position)
      end
    end
    game_over(position)
  end

  def flagging?(position)
    position[:flag]
  end

  def flagged?(position)
    row, col = position[:pos]
    @board.model[row][col].flagged
  end

  def flag(position)
    row, col = position[:pos]

    if @board.model[row][col].flagged
      @board.model[row][col].unflag
      @board.vue[row][col] = ' * '
    else
      @board.model[row][col].flag
      @board.vue[row][col] = ' 🚩'
    end
  end

  def process_user_input(position)
    row, col = position[:pos]

    #! IF NOT FLAGGED, PROCEED TO THE REVELATIONS
    if flagged?(position)
      puts "Impossible: This position is flagged".red
      sleep(1.5)

    # if this tile has stats
    elsif @board.model[row][col].is_adjacent_mine?
      reveal(position[:pos])
    # if this tile is mined
    elsif @board.model[row][col].mined?
      game_over(position[:pos])
    # if this tile is empty
    else
      reveal(position[:pos])
      reveal_around_blank(position[:pos])
    end
  end

  def terminate_if_win
    if @board.num_revealed == ((@board.board_size**2) - @board.num_mines)
      puts "\nYou win!".green
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

  def player_input
    get_input = gets.chomp

    player_input = { pos: [], flag: nil }
    player_input[:pos] << Integer(get_input[0]) rescue nil
    player_input[:pos] << Integer(get_input[1]) rescue nil
    player_input[:flag] = get_input[2] == 'F'

    player_input
  end

  def position_input
    puts "\nEnter the coordinates of a tile to reveal it"
    puts "Add 'F' to flag (e.g. '01F')"
    print '> '
    input = player_input

    loop do
      unless valid_input?(input)
        puts "ERROR! Enter coordinates between 0 and #{board_size}".red
        puts "Add 'F' to flag (e.g. '01F')".red
        print '> '
        input = player_input
        redo
      end

      if revealed?(input)
        puts 'Position already revealed!'.red
        print '> '
        input = player_input
        redo
      else
        break
      end
    end
    input
  end

  def valid_input?(input)
    input[:pos].length == 2 &&
      input[:pos].reduce(&:+) <= (board_size * 2) &&
      input[:flag] == !!input[:flag]
  end

  def board_size
    @board.model.length - 1
  end

  def mined?(position)
    row, col = position[:pos]
    @board.model[row][col].mined?
  end

  def revealed?(position)
    @board.model[position[:pos][0]][position[:pos][1]].revealed
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

ms = MineSweeper.new(5, 2)
ms.play
