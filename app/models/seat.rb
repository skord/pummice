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

  belongs_to :settlement0, :class_name => 'BuildingCard', :foreign_key => "settlement0_id"
  belongs_to :settlement1, :class_name => 'BuildingCard', :foreign_key => "settlement1_id"
  belongs_to :settlement2, :class_name => 'BuildingCard', :foreign_key => "settlement2_id"
  belongs_to :settlement3, :class_name => 'BuildingCard', :foreign_key => "settlement3_id"
  belongs_to :settlement4, :class_name => 'BuildingCard', :foreign_key => "settlement4_id"
  belongs_to :settlement5, :class_name => 'BuildingCard', :foreign_key => "settlement5_id"
  belongs_to :settlement6, :class_name => 'BuildingCard', :foreign_key => "settlement6_id"
  belongs_to :settlement7, :class_name => 'BuildingCard', :foreign_key => "settlement7_id"

  has_many :districts, :as => :districtable
  has_many :plots, :as => :plotable

  def tiles
    [tile00, tile10, tile01, tile11, tile02, tile12, tile03, tile13, tile04, tile14].compact!
  end

  def settlements
    [settlement0, settlement1, settlement2, settlement3, settlement4, settlement5, settlement6, settlement7].compact!
  end

end