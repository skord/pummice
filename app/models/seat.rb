class Seat < ActiveRecord::Base
  attr_accessible :number
  belongs_to :game
  belongs_to :user
  
  belongs_to :tile00, :class_name => 'BuildingCard', :foreign_key => "tile00_id"
  belongs_to :tile10, :class_name => 'BuildingCard', :foreign_key => "tile10_id"
  belongs_to :tile01, :class_name => 'BuildingCard', :foreign_key => "tile01_id"
  belongs_to :tile11, :class_name => 'BuildingCard', :foreign_key => "tile11_id"
  belongs_to :tile02, :class_name => 'BuildingCard', :foreign_key => "tile02_id"
  belongs_to :tile12, :class_name => 'BuildingCard', :foreign_key => "tile12_id"
  belongs_to :tile03, :class_name => 'BuildingCard', :foreign_key => "tile03_id"
  belongs_to :tile13, :class_name => 'BuildingCard', :foreign_key => "tile13_id"
  belongs_to :tile04, :class_name => 'BuildingCard', :foreign_key => "tile04_id"
  belongs_to :tile14, :class_name => 'BuildingCard', :foreign_key => "tile14_id"

end