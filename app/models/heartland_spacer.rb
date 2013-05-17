class HeartlandSpacer
  attr_accessor :position_x, :position_y
  def initialize(pos_x, pos_y)
    @position_x = pos_x
    @position_y = pos_y
  end

  def position_x
    @position_x
  end

  def position_y
    @position_y
  end

  def height
    1
  end

  def width
    5
  end
end
