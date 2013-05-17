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

  def action_for_game_controller(seat)
    # There are at most 2 activities for each building card
    @activities = {0 => {
      :spend_type => :exact,
      :spend_count => 0,
      :spend_resources => {},
      :max_count => 1,
      :max_convert => 0,
      :gains => {}
      }, 
      1 => {}
    }

    case self.key
    when "G02" # Cloister Courtyard
      @activities[0][:spend_type] = :unique
      @activities[0][:spend_count] = 3
      @activities[0][:spend_resources] = get_uniques_hash(seat)
      @activities[0][:gains] = [
        {
          :gain_type => :choice,
          :gain_resources => {
            Game::Resource::WOOD => 6,
            Game::Resource::PEAT => 6,
            Game::Resource::GRAIN => 6,
            Game::Resource::LIVESTOCK => 6,
            Game::Resource::CLAY => 6,
            Game::Resource::COIN => 6
          }
        }
      ]
    when "F03" # Grain Storage
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 1
      }
      @activities[0][:max_convert] = [1, seat.res_coin + 5*seat.res_5coin].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::GRAIN => 6
          }
        }
      ]
    when "I03" # Granary
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 1
      }
      @activities[0][:max_convert] = [1, seat.res_coin + 5*seat.res_5coin].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::GRAIN => 4,
            Game::Resource::BOOK => 1
          }
        }
      ]
    when "F04" # Windmill
      @activities[0][:spend_resources] = {
        Game::Resource::GRAIN => 1
      }
      @activities[0][:max_count] = 7
      @activities[0][:max_convert] = [7, seat.res_grain].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::FLOUR => 1,
            Game::Resource::STRAW => 1
          }
        }
      ]
    when "I04" # Malthouse
      @activities[0][:spend_resources] = {
        Game::Resource::GRAIN => 1
      }
      @activities[0][:max_count] = 0
      @activities[0][:max_convert] = seat.res_grain
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::MALT => 1,
            Game::Resource::STRAW => 1
          }
        }
      ]
    when "I05" # Brewery
      @activities[:joiner] = :andthen_or
      @activities[0][:spend_resources] = {
        Game::Resource::MALT => 1,
        Game::Resource::GRAIN => 1
      }
      @activities[0][:max_count] = 0
      @activities[0][:max_convert] = [seat.res_malt, seat.res_grain].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::BEER => 1
          }
        }
      ]
      @activities[1][:spend_type] = :exact
      @activities[1][:spend_resources] = {
        Game::Resource::BEER => 1
      }
      @activities[1][:max_count] = 1
      @activities[1][:max_convert] = 1 if seat.res_beer > 0 || @activities[0][:max_convert] > 0
      @activities[1][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::COIN => 7
          }
        }
      ]
    when "G06" # Fuel Merchant
      @activities[0][:spend_type] = :fuel_steps
      @activities[0][:spend_resources] = {
        Game::Resource::FUEL => [0,3,6,9]
      }
      @activities[0][:gains] = [
        {
          :gain_type => :steps,
          :gain_resources => {
            Game::Resource::COIN => [0,5,8,10]
          }
        }
      ]
    when "G07" # Peat Coal Kiln
      @activities[:joiner] = :and
      @activities[0][:spend_type] = :none
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::PEATCOAL => 1,
            Game::Resource::COIN => 1
          }
        },
      ]
      @activities[1][:spend_type] = :exact
      @activities[1][:spend_resources] = {
        Game::Resource::PEAT => 1
      }
      @activities[1][:max_count] = 0
      @activities[1][:max_convert] = seat.res_peat
      @activities[1][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::PEATCOAL => 1
          }
        }
      ]
    when "I08" # False Lighthouse
      @activities[0][:spend_type] = :none
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::COIN => 3
          }
        },
        {
          :gain_type => :choice,
          :gain_resources => {
            Game::Resource::BEER => 1,
            Game::Resource::WHISKEY => 1
          }
        }
      ]
    when "I11" # Houseboat
      # Nothing to do here -- just gaining resources
      true
    when "G12" # Stone Merchant
      @activities[0][:spend_type] = :fuel_food
      @activities[0][:spend_resources] = {
        Game::Resource::FOOD => 2,
        Game::Resource::FUEL => 1
      }
      @activities[0][:max_count] = 5
      @activities[0][:max_convert] = 5
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::STONE => 1
          }
        }
      ]
    when "I14" # Sacred Site
      @activities[0][:spend_type] = :none
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::BOOK => 1
          }
        },
        {
          :gain_type => :choice,
          :gain_resources => {
            Game::Resource::GRAIN => 2,
            Game::Resource::MALT => 2
          }
        },
        {
          :gain_type => :choice,
          :gain_resources => {
            Game::Resource::BEER => 1,
            Game::Resource::WHISKEY => 1
          }
        }
      ]
    when "I15" # Druid's House
      @activities[0][:spend_resources] = {
        Game::Resource::BOOK => 1
      }
      @activities[0][:max_convert] = [1, seat.res_book].min
      @activities[0][:gains] = [
        {
          :gain_type => :choice,
          :gain_resources => {
            Game::Resource::WOOD => 5,
            Game::Resource::PEAT => 5,
            Game::Resource::GRAIN => 5,
            Game::Resource::LIVESTOCK => 5,
            Game::Resource::CLAY => 5,
            Game::Resource::COIN => 5
          }
        },
        {
          :gain_type => :choice,
          :gain_resources => {
            Game::Resource::WOOD => 3,
            Game::Resource::PEAT => 3,
            Game::Resource::GRAIN => 3,
            Game::Resource::LIVESTOCK => 3,
            Game::Resource::CLAY => 3,
            Game::Resource::COIN => 3
          }
        }
      ]
    when "I17" # Scriptorium
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 1
      }
      @activities[0][:max_convert] = [1, seat.res_coin + 5*seat.res_5coin].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::BOOK => 1,
            Game::Resource::MEAT => 1,
            Game::Resource::WHISKEY => 1
          }
        }
      ]
    when "G18" # Cloister Workshop
      @activities[:joiner] = :and_or
      @activities[0][:spend_type] = :exact_fuel
      @activities[0][:spend_resources] = {
        Game::Resource::CLAY => 1,
        Game::Resource::FUEL => 1
      }
      @activities[0][:max_count] = 3
      @activities[0][:max_convert] = [3, seat.res_clay].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::CERAMIC => 1
          }
        }
      ]
      @activities[1][:spend_type] = :exact_fuel
      @activities[1][:spend_resources] = {
        Game::Resource::STONE => 1,
        Game::Resource::FUEL => 1
      }
      @activities[1][:max_count] = 1
      @activities[1][:max_convert] = [1, seat.res_stone].min
      @activities[1][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::ORNAMENT => 1
          }
        }
      ]
    when "G19" # Slaughterhouse
      @activities[0][:spend_resources] = {
        Game::Resource::LIVESTOCK => 1,
        Game::Resource::STRAW => 1
      }
      @activities[0][:max_count] = 0
      @activities[0][:max_convert] = [seat.res_livestock, seat.res_straw + seat.res_grain].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::MEAT => 1
          }
        }
      ]
    when "I20" # Alehouse
      @activities[:joiner] = :and_or
      @activities[0][:spend_resources] = {
        Game::Resource::BEER => 1
      }
      @activities[0][:max_count] = 1
      @activities[0][:max_convert] = [1, seat.res_beer].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::COIN => 8
          }
        }
      ]
      @activities[1][:spend_type] = :exact
      @activities[1][:spend_resources] = {
        Game::Resource::WHISKEY => 1
      }
      @activities[1][:max_count] = 1
      @activities[1][:max_convert] = [1, seat.res_whiskey].min
      @activities[1][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::COIN => 7
          }
        }
      ]
    when "I21" # Whiskey Distillery
      @activities[0][:spend_resources] = {
        Game::Resource::MALT => 1,
        Game::Resource::WOOD => 1,
        Game::Resource::PEAT => 1
      }
      @activities[0][:max_count] = 0
      @activities[0][:max_convert] = [seat.res_malt, seat.res_wood, seat.res_peat].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::WHISKEY => 2
          }
        }
      ]
    when "I23" # Locutory
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 2
      }
      @activities[0][:max_convert] = [1, (seat.res_coin + 5 * seat.res_5coin) / 2].min
      @activities[0][:gains] = [
        {
          :gain_type => :special,
          :gain_special => ["take back prior", "and then carry out", "one build a building", "action"],
          :gain_resources => {}
        }
      ]
    when "I24" # Chapel
      @activities[:joiner] = :and_or
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 1
      }
      @activities[0][:max_count] = 1
      @activities[0][:max_convert] = [1, seat.res_coin + 5*seat.res_5coin].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::BOOK => 1
          }
        }
      ]
      @activities[1][:spend_type] = :exact
      @activities[1][:spend_resources] = {
        Game::Resource::BEER => 1,
        Game::Resource::WHISKEY => 1
      }
      @activities[1][:max_count] = 3
      @activities[1][:max_convert] = [3, seat.res_beer, seat.res_whiskey].min
      @activities[1][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::RELIQUERY => 1
          }
        }
      ]
    when "I25" # Portico
      @activities[0][:spend_resources] = {
        Game::Resource::RELIQUERY => 1
      }
      @activities[0][:max_convert] = [1, seat.res_reliquery].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::CLAY => 2,
            Game::Resource::LIVESTOCK => 2,
            Game::Resource::WOOD => 2,
            Game::Resource::GRAIN => 2,
            Game::Resource::PEAT => 2,
            Game::Resource::COIN => 2,
            Game::Resource::STONE => 2
          }
        }
      ]
    when "G26" # Shipyard
      @activities[0][:spend_resources] = {
        Game::Resource::WOOD => 2
      }
      @activities[0][:max_convert] = [1, seat.res_wood / 2].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::ORNAMENT => 1,
            Game::Resource::COINX5 => 1
          }
        }
      ]
    when "I30" # Refectory
      @activities[:joiner] = :and
      @activities[0][:spend_type] = :none
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::BEER => 1,
            Game::Resource::MEAT => 1
          }
        }
      ]
      @activities[1][:spend_type] = :exact
      @activities[1][:spend_resources] = {
        Game::Resource::MEAT => 1
      }
      @activities[1][:max_count] = 4
      @activities[1][:max_convert] = [4, seat.res_meat + 1].min
      @activities[1][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::CERAMIC => 1
          }
        }
      ]
    when "I31" # Coal Harbor
      @activities[0][:spend_type] = :exact
      @activities[0][:spend_resources] = {
        Game::Resource::PEATCOAL => 1
      }
      @activities[0][:max_count] = 3
      @activities[0][:max_convert] = [3, seat.res_peatcoal].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::COIN => 3,
            Game::Resource::WHISKEY => 1
          }
        }
      ]
    when "I32" # Filial Church
      @activities[0][:spend_type] = :unique
      @activities[0][:spend_count] = 5
      @activities[0][:spend_resources] = get_uniques_hash(seat)
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::RELIQUERY => 1
          }
        }
      ]
    when "I33" # Cooperage
      @activities[0][:spend_resources] = {
        Game::Resource::WOOD => 3
      }
      @activities[0][:max_convert] = [1, seat.res_wood / 3].min
      @activities[0][:gains] = [
        {
          :gain_type => :special,
          :gain_special => ["Joker tile for %s or %s" % [seat.game.map_resource(Resource::BEER), seat.game.map_resource(Resource::WHISKEY)]],
          :gain_resources => {}
        }
      ]
    when "G34" # Sacristy
      @activities[0][:spend_resources] = {
        Game::Resource::BOOK => 1,
        Game::Resource::CERAMIC => 1,
        Game::Resource::ORNAMENT => 1,
        Game::Resource::RELIQUERY => 1
      }
      @activities[0][:max_convert] = [1, seat.res_book, seat.res_ceramic, seat.res_ornament, seat.res_reliquery].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::WONDER => 1
          }
        }
      ]
    when "I35" # Round Tower
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 5,
        Game::Resource::WHISKEY => 1,
        Game::Resource::VP => 14
      }
      @activities[:spend_vps] = { }
      # We want to count Whiskeys, but not the one we need to spend
      @activities[:spend_vps][Game::Resource::WHISKEY] = seat.res_whiskey - 1 if seat.res_whiskey - 1 > 0
      # We want to count coins, but not the ones we need to spend
      @activities[:spend_vps][Game::Resource::COINX5] = (seat.res_coin + 5 * seat.res_5coin - 1) / 5 if (seat.res_coin + 5 * seat.res_5coin - 1) / 5 > 0
      @activities[:spend_vps][Game::Resource::BOOK] = seat.res_book if seat.res_book > 0
      @activities[:spend_vps][Game::Resource::CERAMIC] = seat.res_ceramic if seat.res_ceramic > 0
      @activities[:spend_vps][Game::Resource::ORNAMENT] = seat.res_ornament if seat.res_ornament > 0
      @activities[:spend_vps][Game::Resource::RELIQUERY] = seat.res_reliquery if seat.res_reliquery > 0

      vps = 0
      for vp in @activities[:spend_vps]
        case vp.first
        when Game::Resource::WHISKEY
          vps += vp.last
        when Game::Resource::COINX5
          vps += 2 * vp.last
        when Game::Resource::BOOK
          vps += 2 * vp.last
        when Game::Resource::CERAMIC
          vps += 3 * vp.last
        when Game::Resource::ORNAMENT
          vps += 4 * vp.last
        when Game::Resource::RELIQUERY
          vps += 8 * vp.last
        end
      end

      @activities[0][:max_convert] = [1, (seat.res_coin + seat.res_5coin * 5) / 5, seat.res_whiskey, vps / 14].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::WONDER => 1
          }
        }
      ]
    when "I36" # Camera
      @activities[0][:spend_resources] = {
        Game::Resource::BOOK => 1,
        Game::Resource::CERAMIC => 1
      }
      @activities[0][:max_count] = 2
      @activities[0][:max_convert] = [2, seat.res_book, seat.res_ceramic].min
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::COIN => 1,
            Game::Resource::CLAY => 1,
            Game::Resource::RELIQUERY => 1
          }
        }
      ]
    when "I37" # Bulwark
      @activities[0][:spend_resources] = {
        Game::Resource::BOOK => 1
      }
      @activities[0][:max_convert] = [1, seat.res_book].min
      @activities[0][:gains] = [
        {
          :gain_type => :special,
          :gain_special => ["1 free district", "and 1 free plot"],
          :gain_resources => {}
        }
      ]
    when "I38" # Festival Ground
      @activities[0][:spend_resources] = {
        Game::Resource::BEER => 1
      }
      @activities[0][:max_convert] = [1, seat.res_beer].min
      @activities[0][:gains] = [
        {
          :gain_type => :victory_points,
          :gain_resources => {
            Game::Resource::VP => seat.find_building_locations_by_lambda(->(t){ ["R01","R02"].include?(t.key) }).count
            #find_building_locations_by_key("R01").count + seat.find_building_locations_by_key("R02").count
          }
        }
      ]
    when "G39" # Estate
      @activities[0][:spend_type] = :fuel_or_food
      @activities[0][:spend_resources] = {
        Game::Resource::FUEL => 6,
        Game::Resource::FOOD => 10
      }
      @activities[0][:max_count] = 2
      @activities[0][:max_convert] = 2
      @activities[0][:gains] = [
        {
          :gain_type => :exact,
          :gain_resources => {
            Game::Resource::BOOK => 1,
            Game::Resource::ORNAMENT => 1
          }
        }
      ]
    when "G41" # House of the Brotherhood
      @activities[0][:spend_resources] = {
        Game::Resource::COIN => 5
      }
      @activities[0][:max_convert] = [1, (seat.res_coin + 5 * seat.res_5coin) / 5].min
      @activities[0][:gains] = [
        {
          :gain_type => :victory_points,
          :gain_resources => {
            Game::Resource::VP => 2 * seat.find_building_locations_by_lambda(->(t){ t.is_cloister }).count
          }
        }
      ]
    else
      @activities[0].clear()
    end

    # Common setup needed for all payments that require food
    if @activities[0][:spend_resources].has_key?(Game::Resource::FOOD) || (@activities[1][:spend_resources] || {}).has_key?(Game::Resource::FOOD)
      @activities[:spend_foods] = { }
      @activities[:spend_foods][Game::Resource::GRAIN] = seat.res_grain if seat.res_grain > 0
      @activities[:spend_foods][Game::Resource::LIVESTOCK] = seat.res_livestock if seat.res_livestock > 0
      @activities[:spend_foods][Game::Resource::COIN] = seat.res_coin + seat.res_5coin * 5 if seat.res_coin + seat.res_5coin > 0
      @activities[:spend_foods][Game::Resource::GRAPES] = seat.res_grapes if seat.res_grapes > 0
      @activities[:spend_foods][Game::Resource::MALT] = seat.res_malt if seat.res_malt > 0
      @activities[:spend_foods][Game::Resource::FLOUR] = seat.res_flour if seat.res_flour > 0
      @activities[:spend_foods][Game::Resource::WHISKEY] = seat.res_whiskey if seat.res_whiskey > 0
      @activities[:spend_foods][Game::Resource::MEAT] = seat.res_meat if seat.res_meat > 0
      @activities[:spend_foods][Game::Resource::WINE] = seat.res_wine if seat.res_wine > 0
      @activities[:spend_foods][Game::Resource::BEER] = seat.res_beer if seat.res_beer > 0
      @activities[:spend_foods][Game::Resource::BREAD] = seat.res_bread if seat.res_bread > 0
    end

    # Common setup needed for all payments that require fuel
    if @activities[0][:spend_resources].has_key?(Game::Resource::FUEL) || (@activities[1][:spend_resources] || {}).has_key?(Game::Resource::FUEL)
      @activities[:spend_fuels] = { }
      @activities[:spend_fuels][Game::Resource::WOOD] = seat.res_wood if seat.res_wood > 0
      @activities[:spend_fuels][Game::Resource::PEAT] = seat.res_peat if seat.res_peat > 0
      @activities[:spend_fuels][Game::Resource::PEATCOAL] = seat.res_peatcoal if seat.res_peatcoal > 0
      @activities[:spend_fuels][Game::Resource::STRAW] = seat.res_straw + seat.res_grain if seat.res_straw > 0 || seat.res_grain > 0
    end

    return @activities
  end

  def resolve_action(game, seat, params={})
    new_actioncode = nil

    case self.key
    when "R01" # Forest
      return false if Resource::WOOD != params[:resource]
      seat.set_tile_by_location(nil, params[:x], params[:y])
    when "R02" # Moor
      return false if Resource::PEAT != params[:resource]
      seat.set_tile_by_location(nil, params[:x], params[:y])
    when "H01" # Clay Mound
      return false if Resource::CLAY != params[:resource]
    when "H02" # Farmyard
      return false if ![Resource::GRAIN, Resource::LIVESTOCK].include?(params[:resource])
    when "H03" # Cloister Office
      return false if Resource::COIN != params[:resource]
    when "G02" # Cloister Courtyard
      return false if params[:resource_spend].length != 3 || 
        params[:resource_gain_0].length != 1 || 
        ![Resource::WOOD, Resource::PEAT, Resource::LIVESTOCK, Resource::GRAIN, Resource::CLAY, Resource::COIN].include?(params[:resource_gain_0][0])
      for res in params[:resource_spend]
        seat.add_resource(res.first, -res.last)
      end
      seat.add_resource(params[:resource_gain_0][0], 6)
    when "I04" # Malthouse
      convert = [seat.res_grain, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::GRAIN, -convert)
        seat.add_resource(Resource::MALT, convert)
        seat.add_resource(Resource::STRAW, convert)
      end
    when "I05" # Brewery
      convert_malt = [seat.res_malt, seat.res_grain, params[:action_0]].min
      if convert_malt > 0
        seat.add_resource(Resource::MALT, -convert_malt)
        seat.add_resource(Resource::GRAIN, -convert_malt)
        seat.add_resource(Resource::BEER, convert_malt)
      end

      convert_beer = [seat.res_beer, params[:action_1], 1].min
      if convert_beer > 0
        seat.add_resource(Resource::BEER, -convert_beer)
        seat.add_resource(Resource::COIN, 7 * convert_beer)
      end
    when "G06" # Fuel Merchant
      fuel_spent = 0
      for res in params[:resource_spend]
        seat.add_resource(res.first, -res.last)
        case res.first
        when Game::Resource::WOOD
          fuel_spent += res.last
        when Game::Resource::PEAT
          fuel_spent += 2*res.last
        when Game::Resource::STRAW
          fuel_spent += 0.5*res.last
        when Game::Resource::PEATCOAL
          fuel_spent += 3*res.last
        end
      end
      if fuel_spent >= 9
        seat.add_resource(Game::Resource::COIN, 10)
      elsif fuel_spent >= 6
        seat.add_resource(Game::Resource::COIN, 8)
      elsif fuel_spent >= 3
        seat.add_resource(Game::Resource::COIN, 5)
      end
    when "G07" # Peat Coal Kiln
      seat.add_resource(Resource::PEATCOAL, 1)
      seat.add_resource(Resource::COIN, 1)
      convert = [seat.res_peat, params[:action_1]].min
      if convert > 0
        seat.add_resource(Resource::PEAT, -convert)
        seat.add_resource(Resource::PEATCOAL, convert)
      end
    when "I08" # False Lighthouse
      return false if params[:resource_gain_1].length != 1 || 
        ![Resource::BEER, Resource::WHISKEY].include?(params[:resource_gain_1][0])
      seat.add_resource(Resource::COIN, 3)
      seat.add_resource(params[:resource_gain_1][0], 1)
    when "I09" # Spinning Mill
      if seat.res_livestock >= 9
        seat.add_resource(Resource::COIN, 6)
      elsif seat.res_livestock >= 5
        seat.add_resource(Resource::COIN, 5)
      elsif seat.res_livestock >= 1
        seat.add_resource(Resource::COIN, 3)
      end
    when "I10" # Cottage
      if !game.subturns.any?(
          :actioncode => SubturnActionCode::ENTER_BUILDING,
          :parameters => params[:parameters]
        )
        seat.add_resource(Resource::MALT, 1)
        game.actioncode = SubturnActionCode::CHOOSE_TILE_LOCATIONS
      else
        game.actioncode = nil
      end
    when "I11" # Houseboat
      seat.add_resource(Resource::WOOD, 1)
      seat.add_resource(Resource::MALT, 1)
      seat.add_resource(Resource::COIN, 1)
      seat.add_resource(Resource::PEAT, 1)
    when "G12" # Stone Merchant
      fuel_spent = 0
      food_spent = 0
      for res in params[:resource_spend]
        #res_key = Game::Resource.const_get(res.first)
        seat.add_resource(res.first, -res.last)
        case res.first
        when Game::Resource::WOOD
          fuel_spent += res.last
        when Game::Resource::PEAT
          fuel_spent += 2*res.last
        when Game::Resource::STRAW
          fuel_spent += 0.5*res.last
        when Game::Resource::PEATCOAL
          fuel_spent += 3*res.last

        when Game::Resource::GRAIN, Game::Resource::COIN, Game::Resource::GRAPES, Game::Resource::MALT, Game::Resource::FLOUR, Game::Resource::WINE
          food_spent += res.last
        when Game::Resource::LIVESTOCK, Game::Resource::WHISKEY
          food_spent += 2*res.last
        when Game::Resource::COINX5, Game::Resource::MEAT, Game::Resource::BEER
          food_spent += 5*res.last
        when Game::Resource::BREAD
          food_spent += 3*res.last
        end
      end
      if fuel_spent >= 5 && food_spent >= 10
        seat.add_resource(Game::Resource::STONE, 5)
      elsif fuel_spent >= 4 && food_spent >= 8
        seat.add_resource(Game::Resource::STONE, 4)
      elsif fuel_spent >= 3 && food_spent >= 6
        seat.add_resource(Game::Resource::STONE, 3)
      elsif fuel_spent >= 2 && food_spent >= 4
        seat.add_resource(Game::Resource::STONE, 2)
      elsif fuel_spent >= 1 && food_spent >= 2
        seat.add_resource(Game::Resource::STONE, 1)
      end
    when "I14" # Sacred Site
      res2 = params[:resource_gain_1][0]
      res3 = params[:resource_gain_2][0]
      return false if 
        ![Resource::GRAIN, Resource::MALT].include?(res2) ||
        ![Resource::BEER, Resource::WHISKEY].include?(res3)
      seat.add_resource(Resource::BOOK, 1)
      seat.add_resource(res2, 2)
      seat.add_resource(res3, 1)
    when "I15" # Druid's House
      return false if (params[:resource_gain_0]).length != 1 || (params[:resource_gain_1]).length != 1
      if params[:action_0] > 0
        seat.add_resource(Resource::BOOK, -1)
        seat.add_resource(params[:resource_gain_0][0], 5)
        seat.add_resource(params[:resource_gain_1][0], 3)
      end
    when "G16" # Cloister Chapter House
      seat.add_resource(Resource::CLAY, 1)
      seat.add_resource(Resource::LIVESTOCK, 1)
      seat.add_resource(Resource::WOOD, 1)
      seat.add_resource(Resource::GRAIN, 1)
      seat.add_resource(Resource::PEAT, 1)
      seat.add_resource(Resource::COIN, 1)
    when "I17" # Scriptorium
      convert = [seat.res_coin + 5*seat.res_5coin, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::COIN, -convert)
        seat.add_resource(Resource::BOOK, convert)
        seat.add_resource(Resource::MEAT, convert)
        seat.add_resource(Resource::WHISKEY, convert)
      end
    when "G18" # Cloister Workshop
      convert_clay = [seat.res_clay, params[:action_0]].min
      convert_stone = [seat.res_stone, params[:action_1]].min
      fuel_spent = 0
      for res in params[:resource_spend]
        case res.first
        when Game::Resource::WOOD
          fuel_spent += res.last
        when Game::Resource::PEAT
          fuel_spent += 2*res.last
        when Game::Resource::STRAW
          fuel_spent += 0.5*res.last
        when Game::Resource::PEATCOAL
          fuel_spent += 3*res.last
        end
      end
      return false if fuel_spent < convert_clay + convert_stone
      for res in params[:resource_spend]
        seat.add_resource(res.first, -res.last)
      end
      seat.add_resource(Resource::CLAY, -convert_clay)
      seat.add_resource(Resource::CERAMIC, convert_clay)
      seat.add_resource(Resource::STONE, -convert_stone)
      seat.add_resource(Resource::ORNAMENT, convert_stone)
    when "G19" # Slaughterhouse
      convert = [seat.res_livestock, seat.res_straw + seat.res_grain, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::LIVESTOCK, -convert)
        seat.add_resource(Resource::STRAW, -convert)
        seat.add_resource(Resource::MEAT, convert)
      end
    when "I20" # Alehouse
      convert_beer = [seat.res_beer, params[:action_0]].min
      if convert_beer > 0
        seat.add_resource(Resource::BEER, -convert_beer)
        seat.add_resource(Resource::COIN, 8 * convert_beer)
      end
      convert_whiskey = [seat.res_whiskey, params[:action_1]].min
      if convert_whiskey > 0
        seat.add_resource(Resource::WHISKEY, -convert_whiskey)
        seat.add_resource(Resource::COIN, 7 * convert_whiskey)
      end
    when "I21" # Whiskey Distillery
      convert = [seat.res_malt, seat.res_wood, seat.res_peat, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::MALT, -convert)
        seat.add_resource(Resource::WOOD, -convert)
        seat.add_resource(Resource::PEAT, -convert)
        seat.add_resource(Resource::WHISKEY, 2*convert)
      end
    when "G22" # Quarry
      seat.add_resource(Resource::STONE, game.get_production(params[:token]))
    when "I23" # Locutory
      convert = [(seat.res_coin + 5 * seat.res_5coin) / 2, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::COIN, -2)
        seat.prior_location_x = 0
        seat.prior_location_y = 0
        seat.prior_location_seat = nil
        mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::ENTER_BUILDING,
          :parameters => '%s:%s,%s' % [seat.number, mo[2], mo[3]]})
        new_actioncode = SubturnActionCode::BUILD_BUILDING
      end
    when "I24" # Chapel
      convert_coin = [seat.res_coin + 5*seat.res_5coin, params[:action_0]].min
      if convert_coin > 0
        seat.add_resource(Resource::COIN, -convert_coin)
        seat.add_resource(Resource::BOOK, convert_coin)
      end
      convert_beer_whiskey = [seat.res_beer, seat.res_whiskey, params[:action_1]].min
      if convert_beer_whiskey > 0
        seat.add_resource(Resource::BEER, -convert_beer_whiskey)
        seat.add_resource(Resource::WHISKEY, -convert_beer_whiskey)
        seat.add_resource(Resource::RELIQUERY, convert_beer_whiskey)
      end
    when "I25" # Portico
      convert = [1, seat.res_reliquery, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::RELIQUERY, -convert)
        seat.add_resource(Resource::CLAY, 2*convert)
        seat.add_resource(Resource::LIVESTOCK, 2*convert)
        seat.add_resource(Resource::WOOD, 2*convert)
        seat.add_resource(Resource::GRAIN, 2*convert)
        seat.add_resource(Resource::PEAT, 2*convert)
        seat.add_resource(Resource::COIN, 2*convert)
        seat.add_resource(Resource::STONE, 2*convert)
      end
    when "G26" # Shipyard
      convert = [seat.res_wood / 2, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::WOOD, -2 * convert)
        seat.add_resource(Resource::ORNAMENT, convert)
        seat.add_resource(Resource::COINX5, convert)
      end
    when "I30" # Refectory
      seat.add_resource(Resource::BEER, 1)
      seat.add_resource(Resource::MEAT, 1)
      convert = [seat.res_meat, params[:action_1]].min
      if convert > 0
        seat.add_resource(Resource::MEAT, -convert)
        seat.add_resource(Resource::CERAMIC, convert)
      end
    when "I31" # Coal Harbor
      convert = [3, seat.res_peatcoal, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::PEATCOAL, -convert)
        seat.add_resource(Resource::COIN, 3*convert)
        seat.add_resource(Resource::WHISKEY, convert)
      end
    when "I32" # Filial Church
      return false if params[:resource_spend].length != 5
      for res in params[:resource_spend]
        seat.add_resource(res.first, -res.last)
      end
      seat.add_resource(Resource::RELIQUERY, 1)
    when "I33" # Cooperage
      case game.actioncode
      when Subturn::SubturnActionCode::CHOOSE_BUILDING_ACTION
        convert = [seat.res_book, params[:action_0]].min
        if convert > 0
          seat.add_resource(Resource::WOOD, -3)
          mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
          game.subturns << Subturn.new({
            :seat_id => seat.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::CHOOSE_BUILDING_ACTION,
            :parameters => '%s:%s,%s' % [seat.number, mo[2], mo[3]]})
          new_actioncode = SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
        end
      when Subturn::SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
        return false if ![Resource::BEER, Resource::WHISKEY].include?(params[:resource])
        return false if Token::JOKER != params[:token]
      else
        return false
      end
    when "G34" # Sacristy
      convert = [seat.res_book, seat.res_ceramic, seat.res_ornament, seat.res_reliquery, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::BOOK, -1)
        seat.add_resource(Resource::CERAMIC, -1)
        seat.add_resource(Resource::ORNAMENT, -1)
        seat.add_resource(Resource::RELIQUERY, -1)
        seat.add_resource(Resource::WONDER, 1)
      end
    when "I35" # Round Tower
      vps_spent = 0
      for res in params[:resource_spend]
        case res.first
        when Game::Resource::WHISKEY
          vps_spent += res.last
        when Game::Resource::COINX5
          vps_spent += 2*res.last
        when Game::Resource::BOOK
          vps_spent += 2*res.last
        when Game::Resource::CERAMIC
          vps_spent += 3*res.last
        when Game::Resource::ORNAMENT
          vps_spent += 4*res.last
        when Game::Resource::RELIQUERY
          vps_spent += 8*res.last
        end
      end
      convert = [(seat.res_coin + 5 * seat.res_5coin) / 5, seat.res_whiskey, vps_spent, params[:action_0]].min
      if convert > 0
        seat.add_resource(Game::Resource::COINX5, -1)
        seat.add_resource(Game::Resource::WHISKEY, -1)
        for res in params[:resource_spend]
          seat.add_resource(res.first, -res.last)
        end
        seat.add_resource(Game::Resource::WONDER, 1)
      end
    when "I36" # Camera
      convert = [seat.res_book, seat.res_ceramic, params[:action_0]].min
      if convert > 0
        seat.add_resource(Resource::BOOK, -convert)
        seat.add_resource(Resource::CERAMIC, -convert)
        seat.add_resource(Resource::COIN, convert)
        seat.add_resource(Resource::CLAY, convert)
        seat.add_resource(Resource::RELIQUERY, convert)
      end
    when "I37" # Bulwark
      case game.actioncode
      when Subturn::SubturnActionCode::CHOOSE_BUILDING_ACTION
        convert = [seat.res_book, params[:action_0]].min
        if convert > 0
          seat.add_resource(Resource::BOOK, -1)
          district = game.districts.sort_by{|d| d.id}.shift
          seat.districts << district
          game.subturns << Subturn.new({
            :seat_id => seat.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::GAIN_LANDSCAPE,
            :parameters => 'District:%s' % district.id})
          new_actioncode = SubturnActionCode::PLACE_LANDSCAPE
        end
      when Subturn::SubturnActionCode::PLACE_LANDSCAPE
        if game.subturns.last.parameters.starts_with?("District")
          plot = game.plots.sort_by{|p| p.id}.shift
          seat.plots << plot
          game.subturns << Subturn.new({
            :seat_id => seat.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::GAIN_LANDSCAPE,
            :parameters => 'Plot:%s' % plot.id})
          new_actioncode = SubturnActionCode::PLACE_LANDSCAPE
        end
      else
        return false
      end
    when "I38" # Festival Ground
      case game.actioncode
      when Subturn::SubturnActionCode::CHOOSE_BUILDING_ACTION
        convert = [seat.res_beer, params[:action_0]].min
        if convert > 0
          seat.add_resource(Resource::BEER, -1)
          mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
          game.subturns << Subturn.new({
            :seat_id => seat.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::CHOOSE_BUILDING_ACTION,
            :parameters => '%s:%s,%s' % [seat.number, mo[2], mo[3]]})
          new_actioncode = SubturnActionCode::CHOOSE_RESOURCES
        end
      when Subturn::SubturnActionCode::CHOOSE_RESOURCES
        vp_sum = 0
        for res in params[:resource_gain]
          seat.add_resource(res.first, res.last)
          case res.first
          when Game::Resource::BOOK
            vp_sum += 2 * res.last
          when Game::Resource::CERAMIC
            vp_sum += 3 * res.last
          when Game::Resource::ORNAMENT
            vp_sum += 4 * res.last
          when Game::Resource::RELIQUERY
            vp_sum += 8 * res.last
          end
        end
        return false if vp_sum > seat.find_building_locations_by_lambda(->(t){ ["R01","R02"].include?(t.key) }).count
        #find_building_locations_by_key("R01").count + seat.find_building_locations_by_key("R02").count
      else
        return false
      end
    when "G39" # Estate
      fuel_spent = 0
      food_spent = 0
      for res in params[:resource_spend]
        seat.add_resource(res.first, -res.last)
        case res.first
        when Game::Resource::WOOD
          fuel_spent += res.last
        when Game::Resource::PEAT
          fuel_spent += 2*res.last
        when Game::Resource::STRAW
          fuel_spent += 0.5*res.last
        when Game::Resource::PEATCOAL
          fuel_spent += 3*res.last

        when Game::Resource::GRAIN, Game::Resource::COIN, Game::Resource::GRAPES, Game::Resource::MALT, Game::Resource::FLOUR, Game::Resource::WINE
          food_spent += res.last
        when Game::Resource::LIVESTOCK, Game::Resource::WHISKEY
          food_spent += 2*res.last
        when Game::Resource::COINX5, Game::Resource::MEAT, Game::Resource::BEER
          food_spent += 5*res.last
        when Game::Resource::BREAD
          food_spent += 3*res.last
        end
      end
      if fuel_spent >= 12 || food_spent >= 20 || (fuel_spent >= 6 && food_spent >= 10)
        seat.add_resource(Game::Resource::BOOK, 2)
        seat.add_resource(Game::Resource::ORNAMENT, 2)
      elsif fuel_spent >= 6 || food_spent >= 10
        seat.add_resource(Game::Resource::BOOK, 1)
        seat.add_resource(Game::Resource::ORNAMENT, 1)
      end
    when "G41" # House of the Brotherhood
      case game.actioncode
      when Subturn::SubturnActionCode::CHOOSE_BUILDING_ACTION
        convert = [(seat.res_coin + 5 * seat.res_5coin) / 5, params[:action_0]].min
        if convert > 0
          seat.add_resource(Resource::COIN, -5)
          mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
          game.subturns << Subturn.new({
            :seat_id => seat.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::CHOOSE_BUILDING_ACTION,
            :parameters => '%s:%s,%s' % [seat.number, mo[2], mo[3]]})
          new_actioncode = SubturnActionCode::CHOOSE_RESOURCES
        end
      when Subturn::SubturnActionCode::CHOOSE_RESOURCES
        vp_sum = 0
        for res in params[:resource_gain]
          seat.add_resource(res.first, res.last)
          case res.first
          when Game::Resource::BOOK
            vp_sum += 2 * res.last
          when Game::Resource::CERAMIC
            vp_sum += 3 * res.last
          when Game::Resource::ORNAMENT
            vp_sum += 4 * res.last
          when Game::Resource::RELIQUERY
            vp_sum += 8 * res.last
          end
        end
        return false if vp_sum > 2 * seat.find_building_locations_by_lambda(->(t){ t.is_cloister }).count
      else
        return false
      end    else
      return false
    end
    game.actioncode = new_actioncode
    return true
  end

  def get_uniques_hash(seat)
    uniques = {}
    uniques[Resource::WOOD] = 1 if seat.res_wood > 0
    uniques[Resource::PEAT] = 1 if seat.res_peat > 0
    uniques[Resource::GRAIN] = 1 if seat.res_grain > 0
    uniques[Resource::LIVESTOCK] = 1 if seat.res_livestock > 0
    uniques[Resource::CLAY] = 1 if seat.res_clay > 0
    uniques[Resource::COIN] = 1 if seat.res_coin > 0 || seat.res_5coin > 0 || seat.res_whiskey > 1 || seat.res_wine > 1
    uniques[Resource::COINX5] = 1 if seat.res_5coin > 0
    uniques[Resource::STONE] = 1 if seat.res_stone > 0
    uniques[Resource::GRAPES] = 1 if seat.res_grapes > 0
    uniques[Resource::MALT] = 1 if seat.res_malt > 0
    uniques[Resource::FLOUR] = 1 if seat.res_flour > 0
    uniques[Resource::WHISKEY] = 1 if seat.res_whiskey > 0
    uniques[Resource::PEATCOAL] = 1 if seat.res_peatcoal > 0
    uniques[Resource::STRAW] = 1 if seat.res_straw > 0 || seat.res_grain > 1
    uniques[Resource::MEAT] = 1 if seat.res_meat > 0
    uniques[Resource::CERAMIC] = 1 if seat.res_ceramic > 0
    uniques[Resource::BOOK] = 1 if seat.res_book > 0
    uniques[Resource::RELIQUERY] = 1 if seat.res_reliquery > 0
    uniques[Resource::ORNAMENT] = 1 if seat.res_ornament > 0
    uniques[Resource::WINE] = 1 if seat.res_wine > 0
    uniques[Resource::BEER] = 1 if seat.res_beer > 0
    uniques[Resource::BREAD] = 1 if seat.res_bread > 0
    uniques[Resource::WONDER] = 1 if seat.res_wonder > 0
    return uniques
  end
end
