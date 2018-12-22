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
    @content = 'B'
  end

  def empty?
    @has_mine == false
  end

  def mined?
    @has_mine
  end

  def reveal_tile
    @revealed = true
    @content = ' '
  end
end
