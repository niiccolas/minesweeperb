class Tile
  attr_reader :revealed
  attr_accessor :adjacent_mine_count, :content, :coordinates

  def initialize
    @content             = '  '
    @revealed            = false
    @has_mine            = false
    @coordinates         = []
    @adjacent_mine_count = 0
  end

  def plant_mine
    @has_mine = true
    @content = '💩'
  end

  def count_adjacent_mine
    @adjacent_mine_count += 1
    colorize_mine_count
  end

  def colorize_mine_count
    case @adjacent_mine_count
    when 1
      @content = @adjacent_mine_count.to_s.light_blue + ' '
    when 2
      @content = @adjacent_mine_count.to_s.light_green + ' '
    when 3
      @content = @adjacent_mine_count.to_s.light_red + ' '
    when 4
      @content = @adjacent_mine_count.to_s.blue + ' '
    when 5
      @content = @adjacent_mine_count.to_s.green + ' '
    when 6
      @content = @adjacent_mine_count.to_s.red + ' '
    when 7
      @content = @adjacent_mine_count.to_s.magenta + ' '
    when 8
      @content = @adjacent_mine_count.to_s.cyan + ' '
    end
  end

  def empty?
    @has_mine == false
  end

  def mined?
    @has_mine
  end

  def reveal_tile
    @revealed = true
  end
end
