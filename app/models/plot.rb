class Plot < ActiveRecord::Base
  attr_accessible :cost, :side, :tile00_type, :tile10_type, :tile01_type, :tile11_type
  belongs_to :plotable, :polymorphic => true
  
  belongs_to :tile00, :class_name => 'BuildingCard', :foreign_key => "tile00_id"
  belongs_to :tile10, :class_name => 'BuildingCard', :foreign_key => "tile10_id"
  belongs_to :tile01, :class_name => 'BuildingCard', :foreign_key => "tile01_id"
  belongs_to :tile11, :class_name => 'BuildingCard', :foreign_key => "tile11_id"

  def tiles
    [[tile00, tile10], [tile01, tile11]]
  end

end