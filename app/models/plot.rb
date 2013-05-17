class Plot < ActiveRecord::Base
  attr_accessible :cost, :side, :tile00_type, :tile10_type, :tile01_type, :tile11_type
  belongs_to :plotable, :polymorphic => true
  
  belongs_to :tile00, :class_name => 'BuildingCard', :foreign_key => "tile00_id"
  belongs_to :tile10, :class_name => 'BuildingCard', :foreign_key => "tile10_id"
  belongs_to :tile01, :class_name => 'BuildingCard', :foreign_key => "tile01_id"
  belongs_to :tile11, :class_name => 'BuildingCard', :foreign_key => "tile11_id"

  def height
    2
  end

  def width
    2
  end

  def tiles
    [[tile00, tile01], [tile10, tile11]]
  end

  def tile_types
    [[tile00_type, tile01_type], [tile10_type, tile11_type]]
  end

  def contains(x, y)
    return false if position_x == nil || position_y == nil
    return true if y.between?(position_y, position_y+1) && x.between?(position_x, position_x+1)
  end

  def tile(x, y)
    case 10*y+x
    when 00
      return tile00
    when 01
      return tile01
    when 10
      return tile10
    when 11
      return tile11
    end
  end

  def tile_type(x, y)
    case 10*y+x
    when 00
      return tile00_type
    when 01
      return tile01_type
    when 10
      return tile10_type
    when 11
      return tile11_type
    end
  end

  def set_tile_by_location(tile, x, y)
    if x == position_x && y == position_y
      self.tile00 = tile
    elsif x == position_x + 1 && y == position_y
      self.tile01 = tile
    elsif x == position_x && y == position_y + 1
      self.tile10 = tile
    elsif x == position_x + 1 && y == position_y + 1
      raise "This tile is not settable" if self.side == Side::HHM
      self.tile11 = tile
    end
  end
end

class Side
  WWCC = 0
  HHM = 1
end