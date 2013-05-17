class District < ActiveRecord::Base
  attr_accessible :cost, :side, :tile0_type, :tile1_type, :tile2_type, :tile3_type, :tile4_type
  belongs_to :districtable, :polymorphic => true

  belongs_to :tile0, :class_name => 'BuildingCard', :foreign_key => "tile0_id"
  belongs_to :tile1, :class_name => 'BuildingCard', :foreign_key => "tile1_id"
  belongs_to :tile2, :class_name => 'BuildingCard', :foreign_key => "tile2_id"
  belongs_to :tile3, :class_name => 'BuildingCard', :foreign_key => "tile3_id"
  belongs_to :tile4, :class_name => 'BuildingCard', :foreign_key => "tile4_id"

  def height
    1
  end

  def width
    5
  end

  def tiles
    [[tile0, tile1, tile2, tile3, tile4]]
  end

  def tile_types
    [[tile0_type, tile1_type, tile2_type, tile3_type, tile4_type]]
  end

  def contains(x, y)
    return false if position_x == nil || position_y == nil
    return true if y == position_y && x.between?(position_x, position_x+4)
  end

  def tile(x, y=0)
    return nil if y != 0
    case x
    when 0
      return tile0
    when 1
      return tile1
    when 2
      return tile2
    when 3
      return tile3
    when 4
      return tile4
    end
  end

  def tile_type(x, y=0)
    return 0 if y != 0
    case x
    when 0
      return tile0_type
    when 1
      return tile1_type
    when 2
      return tile2_type
    when 3
      return tile3_type
    when 4
      return tile4_type
    end
  end

  def set_tile_by_location(tile, x, y)
    if x == position_x && y == position_y
      self.tile0 = tile
    elsif x == position_x + 1 && y == position_y
      self.tile1 = tile
    elsif x == position_x + 2 && y == position_y
      self.tile2 = tile
    elsif x == position_x + 3 && y == position_y
      self.tile3 = tile
    elsif x == position_x + 4 && y == position_y
      self.tile4 = tile
    end
  end
end

class Side
  MFFHH = 0
  FPPPH = 1
end