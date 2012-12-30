class District < ActiveRecord::Base
  attr_accessible :cost, :side, :tile0_type, :tile1_type, :tile2_type, :tile3_type, :tile4_type
  belongs_to :districtable, :polymorphic => true

  belongs_to :tile0, :class_name => 'BuildingCard', :foreign_key => "tile0_id"
  belongs_to :tile1, :class_name => 'BuildingCard', :foreign_key => "tile1_id"
  belongs_to :tile2, :class_name => 'BuildingCard', :foreign_key => "tile2_id"
  belongs_to :tile3, :class_name => 'BuildingCard', :foreign_key => "tile3_id"
  belongs_to :tile4, :class_name => 'BuildingCard', :foreign_key => "tile4_id"

  def tiles
    [tile0, tile1, tile2, tile3, tile4].compact!
  end

end