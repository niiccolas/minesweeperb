class Tile
  attr_reader :revealed, :content

  def initialize
    @revealed = false
    @has_mine = false
    @content = '*'
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

  def reveal
    @revealed = true
    @content = ' '
  end
end
