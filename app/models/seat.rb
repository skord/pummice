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
    [[tile00, tile01, tile02, tile03, tile04], [tile10, tile11, tile12, tile13, tile14]]
  end

  def settlements
    [settlement0, settlement1, settlement2, settlement3, settlement4, settlement5, settlement6, settlement7].compact!
  end

  def available_basic
    basic_actions = []
    if tiles.flatten.compact!.count{|t| t.key == "R01"} > 0 || 
        districts.count{|d| d.tiles.flatten.compact!.count{|t| t.key == "R01"} > 0} > 0 || 
        plots.count{|p| p.tiles.flatten.compact!.count{|t| t.key == "R01"} > 0} > 0
      wood_production = "%s%s" % [game.wood_production, game.joker_production != game.wood_production ? (" or %s" % game.joker_production) : ""]
    else
      wood_production = "0"
    end
    basic_actions << ["Fell trees (%s)" % wood_production, "1:1"]
    if tiles.flatten.compact!.count{|t| t.key == "R02"} > 0 || 
        districts.count{|d| d.tiles.flatten.compact!.count{|t| t.key == "R02"} > 0} > 0 || 
        plots.count{|p| p.tiles.flatten.compact!.count{|t| t.key == "R02"} > 0} > 0
      peat_production = "%s%s" % [game.peat_production, game.joker_production != game.peat_production ? (" or %s" % game.joker_production) : ""]
    else
      peat_production = "0"
    end
    basic_actions << ["Cut peat (%s)" % peat_production, "1:2"]
    basic_actions
  end

  def available_build
    build_building_actions = []
    for bc in game.building_cards
      if bc.cost_wood <= res_wood && bc.cost_clay <= res_clay && bc.cost_stone <= res_stone && bc.cost_straw <= res_grain + res_straw && bc.cost_coin <= res_coin + 5*res_5coin
        build_building_actions << [bc.name, "3:%s" % bc.id]
      end
    end
    build_building_actions
  end

  def available_enter
    building_actions = []
    if prior_locationX == 0 || clergy0_locationX == 0 || clergy1_locationX == 0
      for x in 0..4
        for y in 0..1
          if tiles[y][x] && tiles[y][x].key[0] != "R" && 
              (prior_locationX != 100 + x || prior_locationY != 100 + y) &&
              (clergy0_locationX != 100 + x || clergy0_locationY != 100 + y) && 
              (clergy1_locationX != 100 + x || clergy1_locationY != 100 + y)
            building_actions << [tiles[y][x].name, "4:%s,%s" % [100 + x, 100 + y]]
          end
        end
      end
    end
    building_actions
  end

  def available_contract
    work_contract_actions = []
    actions["Work contract"] = work_contract_actions if work_contract_actions.count > 0
    work_contract_actions
  end

  def available_extra
    convert_actions = []
    convert_actions << ["Convert Grain -> Straw", "2:1"] if res_grain > 0
    convert_actions << ["Convert 5 Coins -> 5-Coin", "2:2"] if res_coin >= 5
    convert_actions << ["Convert 5-Coin -> 5 Coins", "2:3"] if res_5coin > 0
    convert_actions << ["Buy District Landscape (%s)" % game.districts.first.cost, "2:5"] if game.districts.count > 0 && res_coin + 5*res_5coin >= game.districts.first.cost
    convert_actions << ["Buy Plot Landscape (%s)" % game.plots.first.cost, "2:6"] if game.plots.count > 0 && res_coin + 5*res_5coin >= game.plots.first.cost
    convert_actions
  end

  def available_actions
    actions = {}

    basic_actions = available_basic
    actions["Basic action"] = basic_actions if basic_actions.count > 0

    building_actions = available_enter
    actions["Enter a building"] = building_actions if building_actions.count > 0

    work_contract_actions = available_contract
    actions["Work contract"] = work_contract_actions if work_contract_actions.count > 0

    build_building_actions = available_build
    actions["Build a building"] = build_building_actions if build_building_actions.count > 0

    convert_actions = available_extra
    actions["Extra action"] = convert_actions if convert_actions.count > 0

    return actions
  end

  def available_action_types
    actions = [["Select an action type", "0"]]
    actions << ["Basic action", "1"] if available_basic.count > 0
    actions << ["Enter a building", "4"] if available_enter.count > 0
    actions << ["Work contract", "5"] if available_contract.count > 0
    actions << ["Build a building", "3"] if available_build.count > 0
    actions << ["Extra action", "2"] if available_extra.count > 0

    return actions
  end

end