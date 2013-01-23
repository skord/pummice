class BuildingCard < ActiveRecord::Base
  attr_readonly :name, :variant, :key, :is_base, :is_cloister, :age, :available_location_types, :number_players, :cost_wood, 
                :cost_clay, :cost_stone, :cost_straw, :cost_coin, :cost_fuel, :cost_food, :economic_value, :dwelling_value

  has_many :seats
  has_many :districts
  has_many :plots

  has_and_belongs_to_many :games

  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end

  def map_age
    case age
    when Age::START
      return 'Start'
    when Age::A
      return 'A'
    when Age::B
      return 'B'
    when Age::C
      return 'C'
    when Age::D
      return 'D'
    else
      return ''
    end
  end

  def map_available_location_types
    types = []
    types << "Coast" if (available_location_types & LocationType::COAST) == LocationType::COAST
    types << "Plains" if (available_location_types & LocationType::PLAINS) == LocationType::PLAINS
    types << "Hillside" if (available_location_types & LocationType::HILLSIDE) == LocationType::HILLSIDE
    types << "Mountain" if (available_location_types & LocationType::MOUNTAIN) == LocationType::MOUNTAIN
    types << "Water" if (available_location_types & LocationType::WATER) == LocationType::WATER
    types << "only on Clay Mound" if (available_location_types & LocationType::CLAYMOUND) == LocationType::CLAYMOUND
    return types
  end
end
