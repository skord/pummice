class Seat < ActiveRecord::Base
  attr_accessible :number, :prior_location_x, :prior_location_y, :prior_location_seat_id, :clergy0_location_x, 
        :clergy0_location_y, :clergy1_location_x, :clergy1_location_y
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

  belongs_to :prior_location_seat, :class_name => 'Seat', :foreign_key => "prior_location_seat_id"

  has_many :districts, :as => :districtable
  has_many :plots, :as => :plotable

  def position_x
    heartland_position_x
  end

  def position_y
    heartland_position_y
  end

  def height
    2
  end

  def width
    5
  end

  def save_all
    save
    districts.each do |d|
      d.save
    end
    plots.each do |p|
      p.save
    end
  end

  def get_score
    score = {
      :settlements => {},
      :buildings => 0,
      :goods => 0,
      :total => 0
    }
    tile_array = self.build_tile_array
    for y in 0.step(tile_array[:tile_array].length - 1)
      for x in 0.step(tile_array[:tile_array][y].length - 1)
        tile = tile_array[:tile_array][y][x]
        next if tile == nil

        score[:buildings] += tile.economic_value

        if (tile.key =~ /S\d{2}/) != nil
          score[:settlements][tile.key] = [tile] + self.get_adjacent_tiles(tile_array[:base][0] + x, tile_array[:base][1] + y)
        end
      end
    end
    score[:goods] += 2 * self.get_resource(Game::Resource::BOOK)
    score[:goods] += 3 * self.get_resource(Game::Resource::CERAMIC)
    score[:goods] += 4 * self.get_resource(Game::Resource::ORNAMENT)
    score[:goods] += 8 * self.get_resource(Game::Resource::RELIQUERY)
    score[:goods] += 30 * self.get_resource(Game::Resource::WONDER)
    score[:goods] += 2 * self.get_resource(Game::Resource::COINX5)
    score[:goods] += self.get_resource(Game::Resource::WHISKEY)
    score[:goods] += self.get_resource(Game::Resource::WINE)
    score[:goods] += 1 if [3, 4].include?(self.get_resource(Game::Resource::COIN) % 5) && self.get_resource(Game::Resource::WHISKEY) > 0
    score[:goods] += 1 if [4].include?(self.get_resource(Game::Resource::COIN) % 5) && self.get_resource(Game::Resource::WINE) > 0

    score[:total] = score[:buildings] + score[:goods] + score[:settlements].values.map{|v| v.map{|t| t.dwelling_value}.sum()}.sum()
    return score
  end

  def get_resource(resource_code)
    case resource_code
    when Resource::WOOD
      self.res_wood
    when Resource::PEAT
      self.res_peat
    when Resource::GRAIN
      self.res_grain
    when Resource::LIVESTOCK
      self.res_livestock
    when Resource::CLAY
      self.res_clay
    when Resource::COIN
      self.res_coin
    when Resource::COINX5
      self.res_5coin
    when Resource::STONE
      self.res_stone
    when Resource::GRAPES
      self.res_grapes
    when Resource::MALT
      self.res_malt
    when Resource::FLOUR
      self.res_flour
    when Resource::WHISKEY
      self.res_whiskey
    when Resource::PEATCOAL
      self.res_peatcoal
    when Resource::STRAW
      self.res_straw
    when Resource::MEAT
      self.res_meat
    when Resource::CERAMIC
      self.res_ceramic
    when Resource::BOOK
      self.res_book
    when Resource::RELIQUERY
      self.res_reliquery
    when Resource::ORNAMENT
      self.res_ornament
    when Resource::WINE
      self.res_wine
    when Resource::BEER
      self.res_beer
    when Resource::BREAD
      self.res_bread
    when Resource::WONDER
      self.res_wonder
    when Resource::FUEL
      self.res_wood + 2*self.res_peat + 3*self.res_peatcoal + 0.5*(self.res_grain + self.res_straw)
    when Resource::FOOD
      2*self.res_livestock + 5*self.res_meat + self.res_grapes + self.res_wine + self.res_flour + 3*self.res_bread +
        2*self.res_whiskey + self.res_grain + self.res_coin + 5*self.res_5coin + self.res_malt + 5*self.res_beer
    when Resource::VP
      self.res_wine + self.res_whiskey + 3*self.res_ceramic + 4*self.res_ornament + 2*self.res_book + 
        2*((self.res_coin + 5*self.res_5coin)/5) + 8*self.res_reliquery + 30*self.res_wonder
    when Resource::CURRENCY
      self.res_wine + 2*self.res_whiskey + self.res_coin + 5*self.res_5coin
    end
  end

  def add_resource(resource, amount)
    case resource
    when Resource::WOOD
      self.res_wood += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_wood < 0
    when Resource::PEAT
      self.res_peat += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_peat < 0
    when Resource::GRAIN
      self.res_grain += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_grain < 0
    when Resource::LIVESTOCK
      self.res_livestock += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_livestock < 0
    when Resource::CLAY
      self.res_clay += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_clay < 0
    when Resource::COIN
      self.res_coin += amount
      while self.res_coin < 0 && self.res_5coin > 0
        self.res_5coin -= 1
        self.res_coin += 5
      end
      # Always "chip up"
      while self.res_coin >= 5
        self.res_5coin += 1
        self.res_coin -= 5
      end
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_coin < 0 || self.res_5coin < 0
    when Resource::COINX5
      self.res_5coin += amount
      while self.res_5coin < 0 && self.res_coin >= 5
        self.res_coin -= 5
        self.res_5coin += 1
      end
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_coin < 0 || self.res_5coin < 0
    when Resource::STONE
      self.res_stone += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_stone < 0
    when Resource::GRAPES
      self.res_grapes += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_grapes < 0
    when Resource::MALT
      self.res_malt += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_malt < 0
    when Resource::FLOUR
      self.res_flour += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_flour < 0
    when Resource::WHISKEY
      self.res_whiskey += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_whiskey < 0
    when Resource::PEATCOAL
      self.res_peatcoal += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_peatcoal < 0
    when Resource::STRAW
      self.res_straw += amount
      while self.res_straw < 0 && self.res_grain > 0
        self.res_straw += 1
        self.res_grain -= 1
      end
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_straw < 0 || self.res_grain < 0
    when Resource::MEAT
      self.res_meat += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_meat < 0
    when Resource::CERAMIC
      self.res_ceramic += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_ceramic < 0
    when Resource::BOOK
      self.res_book += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_book < 0
    when Resource::RELIQUERY
      self.res_reliquery += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_reliquery < 0
    when Resource::ORNAMENT
      self.res_ornament += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_ornament < 0
    when Resource::WINE
      self.res_wine += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_wine < 0
    when Resource::BEER
      self.res_beer += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_beer < 0
    when Resource::BREAD
      self.res_bread += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_bread < 0
    when Resource::WONDER
      self.res_wonder += amount
      raise RangeError, "%s ended up negative" % [game.map_resource(resource)] if self.res_wonder < 0
    end
  end

  def tiles
    [[tile00, tile01, tile02, tile03, tile04], [tile10, tile11, tile12, tile13, tile14]]
  end

  def tile(x, y)
    return tiles[y][x] if y >= 0 && y < height && x >= 0 && x < width
  end

  def tile_types
    [[Game::LocationType::PLAINS, Game::LocationType::PLAINS, Game::LocationType::PLAINS, Game::LocationType::PLAINS, Game::LocationType::CLAYMOUND],
    [Game::LocationType::PLAINS, Game::LocationType::PLAINS, Game::LocationType::PLAINS, Game::LocationType::PLAINS, Game::LocationType::PLAINS]]
  end

  def tile_type(x, y)
    return tile_types[y][x] if y >= 0 && y < height && x >= 0 && x < width
  end

  def settlements
    [settlement0, settlement1, settlement2, settlement3, settlement4, settlement5, settlement6, settlement7].compact!
  end

  def delete_settlement(settlement_id)
    if settlement_id == settlement0
      self.settlement0 = nil
    elsif settlement_id == settlement1
      self.settlement1 = nil
    elsif settlement_id == settlement2
      self.settlement2 = nil
    elsif settlement_id == settlement3
      self.settlement3 = nil
    elsif settlement_id == settlement4
      self.settlement4 = nil
    elsif settlement_id == settlement5
      self.settlement5 = nil
    elsif settlement_id == settlement6
      self.settlement6 = nil
    elsif settlement_id == settlement7
      self.settlement7 = nil
    end
  end

  def build_tile_array
    center_base = [heartland_position_x, heartland_position_y]
    tile_array = Array.new(tiles)
    for d in districts.sort_by{|district| (district.position_y || -1)}
      next if not d.position_x
      if d.position_y < center_base[1]
        tile_array.insert(0, d.tiles[0])
        center_base[1] -= d.height
      elsif d.position_y > center_base[1]
        tile_array << d.tiles[0]
      end
    end
    left_base = [nil, nil]
    left_tiles = []
    right_base = [nil, nil]
      right_tiles = []
    for p in plots.sort_by{|plot| [plot.position_x || -1, plot.position_y || -1]}
      next if not p.position_x
      if p.position_x < center_base[0] # Left-hand plot
        left_base = [p.position_x, p.position_y] if !left_base[0]
        while left_base[1]+left_tiles.length+1 < p.position_y
          left_tiles << [nil] * p.width
        end
        for y in 0.step(p.height - 1)
          left_tiles << p.tiles[y]
        end
      else # Right-hand plot
        right_base = [p.position_x, p.position_y] if !right_base[0]
        while right_base[1]+right_tiles.length+1 < p.position_y
          right_tiles << [nil] * p.width
        end
        for y in 0.step(p.height - 1)
          right_tiles << p.tiles[y]
        end
      end
    end
    # Generate the 'base' by comparing the central heartland/district section with the left & right plot sections
    base = [
      [left_base[0]||center_base[0], center_base[0], right_base[0]||center_base[0]].min, 
      [left_base[1]||center_base[1], center_base[1], right_base[1]||center_base[1]].min]

    # Normalize the number & positions of items in each of the arrays
    while left_base[0] && left_base[1] > base[1]
      left_tiles.insert(0, [nil] * left_tiles[0].length)
      left_base[1] -= 1
    end
    while center_base[1] > base[1]
      tile_array.insert(0, [nil] * tile_array[0].length)
      center_base[1] -= 1
    end
    while right_base[0] && right_base[1] > base[1]
      right_tiles.insert(0, [nil] * right_tiles[0].length)
      right_base[1] -= 1
    end
    while left_base[0] && left_tiles.length < [tile_array.length, right_tiles.length].max
      left_tiles << [nil] * left_tiles[0].length
    end
    while tile_array.length < [left_tiles.length, right_tiles.length].max
      tile_array << [nil] * tile_array[0].length
    end
    while right_base[0] && right_tiles.length < [left_tiles.length, tile_array.length].max
      right_tiles << [nil] * right_tiles[0].length
    end

    # Now we can smash it all together
    for y in 0.step(tile_array.length - 1)
      tile_array[y] = (left_base[0] ? left_tiles[y] : []) + tile_array[y] + (right_base[0] ? right_tiles[y] : [])
    end

    return {:base => base, :tile_array => tile_array}
  end

  def districts_above
    da = []
    for d in districts
      da << d if d.position_y != nil && d.position_y < 100
    end
    da.sort! {|d1, d2| d1.position_y <=> d2.position_y}
  end

  def districts_below
    db = []
    for d in districts
      db << d if d.position_y != nil && d.position_y > 100
    end
    db.sort! {|d1, d2| d1.position_y <=> d2.position_y}
  end

  def plots_left
    pl = []
    for p in plots
      pl << p if p.position_x != nil && p.position_x < 100
    end
    pl.sort! {|p1, p2| p1.position_y <=> p2.position_y}
  end

  def plots_right
    pr = []
    for p in plots
      pr << p if p.position_x != nil && p.position_x > 100
    end
    pr.sort! {|p1, p2| p1.position_y <=> p2.position_y}
  end

  def set_tile_by_location(tile, x, y)
    if x == heartland_position_x && y == heartland_position_y
      self.tile00 = tile
    elsif x == heartland_position_x + 1 && y == heartland_position_y
      self.tile01 = tile
    elsif x == heartland_position_x + 2 && y == heartland_position_y
      self.tile02 = tile
    elsif x == heartland_position_x + 3 && y == heartland_position_y
      self.tile03 = tile
    elsif x == heartland_position_x + 4 && y == heartland_position_y
      self.tile04 = tile
    elsif x == heartland_position_x && y == heartland_position_y + 1
      self.tile10 = tile
    elsif x == heartland_position_x + 1 && y == heartland_position_y + 1
      self.tile11 = tile
    elsif x == heartland_position_x + 2 && y == heartland_position_y + 1
      self.tile12 = tile
    elsif x == heartland_position_x + 3 && y == heartland_position_y + 1
      self.tile13 = tile
    elsif x == heartland_position_x + 4 && y == heartland_position_y + 1
      self.tile14 = tile
    else
      for d in districts
        if y >= d.position_y && y <= d.position_y + d.height - 1 && x >= d.position_x && x <= d.position_x + d.width - 1
          d.set_tile_by_location(tile, x, y)
          return
        end
      end
      for p in plots
        if y >= p.position_y && y <= p.position_y + p.height - 1 && x >= p.position_x && x <= p.position_x + p.width - 1
          p.set_tile_by_location(tile, x, y)
          return
        end
      end
    end
  end

  def find_tile_by_location(x, y)
    if x.between?(heartland_position_x, heartland_position_x+width-1)
      if y.between?(heartland_position_y, heartland_position_y+height-1)
        return tiles[y - heartland_position_y][x - heartland_position_x]
      end
      d = districts.select{|d| d.contains(x, y)}.first
      return d.tile(x - d.position_x) if d
    end
    p = plots.select{|p| p.contains(x, y) }.first
    return p.tile(x - p.position_x, y - p.position_y) if p
    return nil
    # ta = build_tile_array
    # if x < ta[:base][0] || y < ta[:base][1] || x >= ta[:base][0] + ta[:tile_array][0].length || y >= ta[:base][1] + ta[:tile_array].length
    #   return nil
    # end
    # return ta[:tile_array][y - ta[:base][1]][x - ta[:base][0]]
  end

  def get_adjacent_tiles(x, y)
    return [find_tile_by_location(x-1, y), find_tile_by_location(x+1, y), find_tile_by_location(x, y-1), find_tile_by_location(x, y+1)].compact
  end

  def find_allowable_tile_locations(building)
    locations = []
    for x in 0..4
      for y in 0..1
        locations << [position_x+x, position_y+y] if !tiles[y][x] && (building.available_location_types & tile_types[y][x]) == tile_types[y][x] && 
          (!building.is_cloister || get_adjacent_tiles(position_x+x, position_y+y).any?{|t| t && t.is_cloister})
      end
    end

    for d in districts
      for x in 0..4
        locations << [d.position_x+x, d.position_y] if !d.tile(x) && (building.available_location_types & d.tile_type(x)) == d.tile_type(x) && 
          (!building.is_cloister || get_adjacent_tiles(d.position_x+x, d.position_y).any?{|t| t && t.is_cloister})
      end
    end

    for p in plots
      for x in 0..1
        for y in 0..1
          locations << [p.position_x+x, p.position_y+y] if !p.tile(x, y) && p.tile_type(x, y) && (building.available_location_types & p.tile_type(x, y)) == p.tile_type(x, y) && 
            (!building.is_cloister || get_adjacent_tiles(p.position_x+x, p.position_y+y).any?{|t| t && t.is_cloister})
        end
      end
    end

    return locations
  end

  def find_building_locations_by_lambda(tile_filter)
    locations = []
    for x in 0..4
      for y in 0..1
        locations << [heartland_position_x+x, heartland_position_y+y] if tiles[y][x] && tile_filter.call(tiles[y][x])
      end
    end
    for d in districts
      for x in 0..4
        locations << [d.position_x+x, d.position_y] if d.tile(x) && tile_filter.call(d.tile(x))
      end
    end
    for p in plots
      for x in 0..1
        for y in 0..1
          locations << [p.position_x+x, p.position_y+y] if p.tile(x, y) && tile_filter.call(p.tile(x, y))
        end
      end
    end
    return locations
  end

  def available_basic
    basic_actions = []
    return basic_actions if game.action_taken
    return basic_actions if ![Phase::NORMAL, Phase::BONUS, Phase::FINALACTION].include?(game.phase)

    if tiles.flatten.compact.any?{|t| t.key == "R01"} || 
        districts.any?{|d| d.tiles.flatten.compact.any?{|t| t.key == "R01"}} || 
        plots.any?{|p| p.tiles.flatten.compact.any?{|t| t.key == "R01"}}
      wood_production = "%s%s" % [game.wood_production, game.joker_production != game.wood_production ? (" or %s" % game.joker_production) : ""]
    else
      wood_production = "0"
    end
    basic_actions << ["Fell trees (%s)" % wood_production, "201:1"]
    if tiles.flatten.compact.any?{|t| t.key == "R02"} || 
        districts.any?{|d| d.tiles.flatten.compact.any?{|t| t.key == "R02"}} || 
        plots.any?{|p| p.tiles.flatten.compact.any?{|t| t.key == "R02"}}
      peat_production = "%s%s" % [game.peat_production, game.joker_production != game.peat_production ? (" or %s" % game.joker_production) : ""]
    else
      peat_production = "0"
    end
    basic_actions << ["Cut peat (%s)" % peat_production, "201:2"]
    basic_actions
  end

  def available_build(phase=nil)
    build_building_actions = []
    return build_building_actions if !phase && game.action_taken

    case phase || game.phase
    when Phase::NORMAL, Phase::BONUS
      for bc in game.building_cards.sort_by{|b| b.id}
        if bc.cost_wood <= res_wood && 
          bc.cost_clay <= res_clay && 
          bc.cost_stone <= res_stone && 
          bc.cost_straw <= res_grain + res_straw && 
          bc.cost_coin <= res_coin + 5*res_5coin &&
          find_allowable_tile_locations(bc).count != 0
          build_building_actions << ["%s (%s)" % [bc.name, bc.key], "203:%s" % bc.id]
        end
      end
    when Phase::SETTLEMENT
      for s in settlements.compact
        if s.cost_fuel <= res_wood + res_peat * 2 + res_peatcoal * 3 + (res_straw + res_grain) * 0.5 &&
          s.cost_food <= res_livestock * 2 + res_meat * 5 + res_grain + res_coin + res_5coin * 5 + res_whiskey * 2 + res_flour + res_bread * 3 + res_grapes + res_wine + res_malt + res_beer * 5 &&
          find_allowable_tile_locations(s).count != 0
          build_building_actions << ["%s (%s)" % [s.name, s.key], "203:%s" % s.id]
        end
      end
    end
    build_building_actions
  end

  def available_enter(from=nil, key="204")
    building_actions = []
    return building_actions if self == from
    return building_actions if game.action_taken
    return building_actions if ![Phase::NORMAL, Phase::BONUS, Phase::FINALACTION].include?(game.phase)

    if prior_location_x == 0 || clergy0_location_x == 0 || clergy1_location_x == 0 || game.phase == Phase::BONUS
      for x in 0..4
        for y in 0..1
          if tiles[y][x] && !["R", "S"].include?(tiles[y][x].key[0]) && 
              (((prior_location_x != position_x + x || prior_location_y != position_y + y) &&
              (clergy0_location_x != position_x + x || clergy0_location_y != position_y + y) && 
              (clergy1_location_x != position_x + x || clergy1_location_y != position_y + y)) || 
                game.phase == Phase::BONUS)
            building_actions << [tiles[y][x].name, "%s:%s:%s,%s" % [key, self.number, position_x + x, position_y + y]]
          end
        end
      end
      for d in districts
        for x in 0.step(d.width - 1)
          for y in 0.step(d.height - 1)
            if d.tile(x, y) && !["R", "S"].include?(d.tile(x, y).key[0]) && 
                (((prior_location_x != d.position_x + x || prior_location_y != d.position_y + y) &&
                (clergy0_location_x != d.position_x + x || clergy0_location_y != d.position_y + y) && 
                (clergy1_location_x != d.position_x + x || clergy1_location_y != d.position_y + y)) || 
                  game.phase == Phase::BONUS)
              building_actions << [d.tile(x, y).name, "%s:%s:%s,%s" % [key, self.number, d.position_x + x, d.position_y + y]]
            end
          end
        end
      end
      for p in plots
        for x in 0.step(p.width - 1)
          for y in 0.step(p.height - 1)
            if p.tile(x, y) && !["R", "S"].include?(p.tile(x, y).key[0]) && 
                (((prior_location_x != p.position_x + x || prior_location_y != p.position_y + y) &&
                (clergy0_location_x != p.position_x + x || clergy0_location_y != p.position_y + y) && 
                (clergy1_location_x != p.position_x + x || clergy1_location_y != p.position_y + y)) || 
                  game.phase == Phase::BONUS)
              building_actions << [p.tile(x, y).name, "%s:%s:%s,%s" % [key, self.number, p.position_x + x, p.position_y + y]]
            end
          end
        end
      end
    end
    return building_actions if from
    all_building_actions = []
    all_building_actions << ["My buildings", building_actions] if building_actions.count > 0
    if game.phase == Phase::BONUS
      for seat in game.seats
        next if seat == self
        all_building_actions << ["%s's buildings" % seat.user.fullname, seat.available_enter(self)]
      end
    end
    all_building_actions
  end

  def available_contract
    work_contract_actions = []
    return work_contract_actions if game.action_taken
    return work_contract_actions if ![Phase::NORMAL, Phase::BONUS, Phase::FINALACTION].include?(game.phase)
    return work_contract_actions if get_resource(Resource::WHISKEY) == 0 && get_resource(Resource::WINE) == 0 && get_resource(Resource::COIN) + 5*get_resource(Resource::COINX5) < game.work_contract_price
    
    for seat in game.seats
      next if seat == self
      buildings = seat.available_enter(self, "205")
      next if buildings.length == 0
      work_contract_actions << ["%s's buildings" % seat.user.fullname, buildings]
    end
    work_contract_actions
  end

  def available_extra
    convert_actions = []
    convert_actions << ["Convert Resources", "202:1"] if res_grain > 0 || res_wine > 0 || res_whiskey > 0 && game.phase != Phase::ENDGAME
    convert_actions << ["Buy District Landscape (%s coins)" % game.districts.sort_by{|d| d.id}.first.cost, "202:5"] if !game.landscape_purchased && game.districts.count > 0 && res_coin + 5 * res_5coin >= game.districts.sort_by{|d| d.id}.first.cost && game.phase != Phase::ENDGAME
    convert_actions << ["Buy Plot Landscape (%s coins)" % game.plots.sort_by{|p| p.id}.first.cost, "202:6"] if !game.landscape_purchased && game.plots.count > 0 && res_coin + 5 * res_5coin >= game.plots.sort_by{|p| p.id}.first.cost && game.phase != Phase::ENDGAME
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
    actions << ["Basic action", "201"] if available_basic.count > 0
    actions << ["Enter a building", "204"] if available_enter.count > 0
    actions << ["Work contract", "205"] if available_contract.count > 0
    actions << ["Build a building", "203"] if available_build.count > 0
    actions << ["Extra action", "202"] if available_extra.count > 0
    actions << ["End turn", "209"] if (game.action_taken && game.actioncode == nil) || game.phase == Phase::SETTLEMENT

    return actions
  end

  def perform_action(params)
    case params[:game][:action_types]

    when "201" # Basic action
      case params[:game][:action_basic]
      when "201:1" # Fell trees
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::FELL_TREES})
        game.actioncode = SubturnActionCode::CHOOSE_TILE_LOCATIONS
        game.save
      when "201:2" # Cut peat
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::CUT_PEAT})
        game.actioncode = SubturnActionCode::CHOOSE_TILE_LOCATIONS
        game.save
      end

    when "202" # Extra actions
      case params[:game][:action_extra]
      when "202:1" # Convert resources
        game.actioncode = SubturnActionCode::CONVERT_RESOURCES
        game.save

      when "202:5" # Buy district
        district = game.districts.sort_by{|d| d.id}.shift
        self.add_resource(Resource::COIN, -district.cost)
        self.districts << district
        self.save_all
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::BUY_LANDSCAPE,
          :parameters => 'District:%s' % district.id})
        game.actioncode = SubturnActionCode::PLACE_LANDSCAPE
        game.save

      when "202:6" # Buy plot
        plot = game.plots.sort_by{|p| p.id}.shift
        self.add_resource(Resource::COIN, -plot.cost)
        self.plots << plot
        self.save_all
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::BUY_LANDSCAPE,
          :parameters => 'Plot:%s' % plot.id})
        game.actioncode = SubturnActionCode::PLACE_LANDSCAPE
        game.save

      end

    when "203" # Build a building
      mo = params[:game][:action_build].match(/(\d+):(\d+)/)
      game.subturns << Subturn.new({
        :seat_id => self.id, 
        :timestamp => Time.now, 
        :actioncode => SubturnActionCode::BUILD_BUILDING,
        :parameters => mo[2]})
      game.actioncode = SubturnActionCode::CHOOSE_TILE_LOCATIONS
      game.save

    when "204" # Enter a building
      mo = params[:game][:action_enter].match(/(\d+):(\d+):(\d+),(\d+)/)
      return if mo == nil || mo[1].to_i != 204
      if game.phase == Phase::NORMAL && prior_location_x == 0 && (clergy0_location_x == 0 || clergy1_location_x == 0)
        # We need to figure out which clergy member to use
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::CHOOSE_TILE_LOCATIONS,
          :parameters => '%s:%s,%s' % [mo[2], mo[3], mo[4]]})
        game.actioncode = SubturnActionCode::CHOOSE_CLERGY_MEMBER
        game.save
      else
        case self.prior_location_x == 0 ? 2 : (self.clergy0_location_x == 0 ? 0 : 1)
        when 0
          self.clergy0_location_x = mo[3].to_i
          self.clergy0_location_y = mo[4].to_i
        when 1
          self.clergy1_location_x = mo[3].to_i
          self.clergy1_location_y = mo[4].to_i
        when 2
          self.prior_location_seat = game.find_seat_by_number(mo[2].to_i)
          self.prior_location_x = mo[3].to_i
          self.prior_location_y = mo[4].to_i
        end
        self.save_all
        enter_building(nil, game.find_seat_by_number(mo[2].to_i), mo[3].to_i, mo[4].to_i)
      end

    when "205" # Work Contract
      mo = params[:game][:action_contract].match(/(\d+):(\d+):(\d+),(\d+)/)
      return if mo == nil || mo[1].to_i != 205
      # First step is to pay for the work contract
      if !params[:game][:contract_paid] && 
          (self.res_wine > 0 || self.res_whiskey > 0) && 
          (self.res_coin + 5*self.res_5coin) >= game.work_contract_price
        # We need to pay for the work contract in 1 of 2 ways
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::WORK_CONTRACT,
          :parameters => '%s:%s,%s' % [mo[2], mo[3], mo[4]]})
        game.actioncode = SubturnActionCode::CHOOSE_RESOURCES
        game.save
        return
      end
      other_seat = game.find_seat_by_number(mo[2].to_i)
      if !params[:game][:contract_paid]
        if self.res_coin + 5*self.res_5coin >= game.work_contract_price
          self.add_resource(Resource::COIN, -game.work_contract_price)
          self.save_all
          other_seat.add_resource(Resource::COIN, game.work_contract_price)
          other_seat.save_all
        elsif self.get_resource(Resource::WHISKEY) > 0
          self.add_resource(Resource::WHISKEY, -1)
          self.save_all
        elsif self.get_resource(Resource::WINE) > 0
          self.add_resource(Resource::WHISKEY, -1)
          self.save_all
        else
          return
        end
      end
      if game.phase == Phase::NORMAL && other_seat.prior_location_x == 0 && (other_seat.clergy0_location_x == 0 || other_seat.clergy1_location_x == 0)
        # We need to figure out which clergy member to use
        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::WORK_CONTRACT,
          :parameters => '%s:%s,%s' % [mo[2], mo[3], mo[4]]})
        game.action_seat = other_seat
        game.actioncode = SubturnActionCode::CHOOSE_CLERGY_MEMBER
        game.save
        return
      else
        case other_seat.prior_location_x == 0 ? 2 : (other_seat.clergy0_location_x == 0 ? 0 : 1)
        when 0
          other_seat.clergy0_location_x = mo[3].to_i
          other_seat.clergy0_location_y = mo[4].to_i
        when 1
          other_seat.clergy1_location_x = mo[3].to_i
          other_seat.clergy1_location_y = mo[4].to_i
        when 2
          other_seat.prior_location_seat = game.find_seat_by_number(mo[2].to_i)
          other_seat.prior_location_x = mo[3].to_i
          other_seat.prior_location_y = mo[4].to_i
        end
        other_seat.save_all
        enter_building(nil, other_seat, mo[3].to_i, mo[4].to_i)
      end

    when "209" # End turn
      game.next_turn

    else
      case game.actioncode
      when Subturn::SubturnActionCode::CHOOSE_TILE_LOCATIONS
        case game.subturns.last.actioncode
        when Subturn::SubturnActionCode::FELL_TREES
          for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
            return if tileP[0].to_i != self.number
            tile = find_tile_by_location(tileP[1].to_i, tileP[2].to_i)
            return if tile == nil || tile.key != "R01"
            game.subturns << Subturn.new({
              :seat_id => self.id, 
              :timestamp => Time.now, 
              :actioncode => SubturnActionCode::CHOOSE_TILE_LOCATIONS,
              :parameters => '%s:%s,%s' % [tileP[0], tileP[1], tileP[2]]})
            game.actioncode = SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
            game.save
          end
        when Subturn::SubturnActionCode::CUT_PEAT
          for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
            return if tileP[0].to_i != self.number
            tile = find_tile_by_location(tileP[1].to_i, tileP[2].to_i)
            return if tile == nil || tile.key != "R02"
            game.subturns << Subturn.new({
              :seat_id => self.id, 
              :timestamp => Time.now, 
              :actioncode => SubturnActionCode::CHOOSE_TILE_LOCATIONS,
              :parameters => '%s:%s,%s' % [tileP[0], tileP[1], tileP[2]]})
            game.actioncode = SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
            game.save
          end
        when Subturn::SubturnActionCode::BUILD_BUILDING
          for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
            return if tileP[0].to_i != self.number
            tile = find_tile_by_location(tileP[1].to_i, tileP[2].to_i)
            return if tile != nil

            building = BuildingCard.find(game.subturns.last.parameters.to_i)
            if building.key[0] == "S" # This is a Settlement & the player must choose which resources to spend
              self.set_tile_by_location(building, tileP[1].to_i, tileP[2].to_i)
              self.delete_settlement(building)
              self.save_all
              game.subturns << Subturn.new({
                :seat_id => self.id, 
                :timestamp => Time.now, 
                :actioncode => SubturnActionCode::CHOOSE_TILE_LOCATIONS,
                :parameters => '%s:%s,%s' % [tileP[0], tileP[1], tileP[2]]})
              game.actioncode = SubturnActionCode::CHOOSE_RESOURCES
              game.save
            else
              self.add_resource(Resource::WOOD, -building.cost_wood)
              self.add_resource(Resource::CLAY, -building.cost_clay)
              self.add_resource(Resource::STONE, -building.cost_stone)
              self.add_resource(Resource::STRAW, -building.cost_straw)
              self.add_resource(Resource::COIN, -building.cost_coin)
              # If we don't have enough Straw, we will automatically
              # convert the appropriate amount of Grain to Straw
              if self.res_straw < 0
                game.subturns << Subturn.new({
                  :seat_id => self.id, 
                  :timestamp => Time.now, 
                  :actioncode => SubturnActionCode::CONVERT_RESOURCES,
                  :parameters => 'Grain:%s' % [-self.res_straw]})
                self.res_grain += self.res_straw
                self.res_straw = 0
              end
              game.building_cards.delete(building)
              self.set_tile_by_location(building, tileP[1].to_i, tileP[2].to_i)
              self.save_all
              game.subturns << Subturn.new({
                :seat_id => self.id, 
                :timestamp => Time.now, 
                :actioncode => SubturnActionCode::CHOOSE_TILE_LOCATIONS,
                :parameters => '%s:%s,%s' % [tileP[0], tileP[1], tileP[2]]})
              if self.prior_location_x == 0
                game.actioncode = SubturnActionCode::DECIDE_ENTER_BUILDING
              else
                game.actioncode = nil
                game.actions_taken += 1
              end
              game.save
            end
          end
        when Subturn::SubturnActionCode::ENTER_BUILDING
          mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
          building = game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)
          case building.key
          when "G01" # Priory
            binding.pry
            for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
              priory_seat = game.find_seat_by_number(tileP[0].to_i)
              next if !priory_seat || priory_seat.prior_location_x != tileP[1].to_i || priory_seat.prior_location_y != tileP[2].to_i
              enter_building(nil, priory_seat, tileP[1].to_i, tileP[2].to_i)
              break
            end
          when "I10" # Cottage
            binding.pry
            for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
              seat = game.find_seat_by_number(tileP[0].to_i)
              next if !seat
              next if seat.prior_location_x == tileP[1].to_i && seat.prior_location_y == tileP[2].to_i && seat.prior_location_seat == seat
              next if seat.clergy0_location_x == tileP[1].to_i && seat.clergy0_location_y == tileP[2].to_i
              next if seat.clergy1_location_x == tileP[1].to_i && seat.clergy1_location_y == tileP[2].to_i
              enter_building(nil, seat, tileP[1].to_i, tileP[2].to_i)
              break
            end
          when "I27" # Grand Manor
            for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
              ob_seat = game.find_seat_by_number(tileP[0].to_i)
              next if !ob_seat
              next if (!(ob_seat.prior_location_x == tileP[1].to_i && ob_seat.prior_location_y == tileP[2].to_i) &&
                  !(ob_seat.clergy0_location_x == tileP[1].to_i && ob_seat.clergy0_location_y == tileP[2].to_i) &&
                  !(ob_seat.clergy1_location_x == tileP[1].to_i && ob_seat.clergy1_location_y == tileP[2].to_i))
              self.add_resource(Resource::WHISKEY, -1)
              enter_building(nil, ob_seat, tileP[1].to_i, tileP[2].to_i)
              break
            end
          when "I29" # Forest Hut
            for tileP in params[:game][:selected_tiles].scan(/(\d+):(\d+),(\d+)/)
              return if tileP[0].to_i != self.number
              tile = find_tile_by_location(tileP[1].to_i, tileP[2].to_i)
              if tile != nil && tile.key == "R01"
                self.set_tile_by_location(nil, tileP[1].to_i, tileP[2].to_i)
                self.add_resource(Resource::LIVESTOCK, 2)
                self.add_resource(Resource::WOOD, 2)
                self.add_resource(Resource::STONE, 1)
              end
              self.save_all
              game.actioncode = nil
              game.actions_taken += 1
              game.save
            end
          when "I40" # Guesthouse
            unbuilt_building = BuildingCard.find(params[:game][:action_enter_unbuilt].to_i)
            return if !game.building_cards.include?(unbuilt_building)
            enter_building(unbuilt_building)
          end
        end
      when SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
        resource, token = params[:game][:action_production_token].split(':').map{|x| x.to_i};
        mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)

        # New refactoring of CHOOSE_BUILDING_ACTION -- shoving things into the BuildingCard class
        building = game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)
        is_success = building.resolve_action(game, self, :resource => resource, :token => token, :x => mo[2].to_i, :y => mo[3].to_i)
        if is_success
          self.save_all
          game.actioncode = nil
          game.actions_taken += 1
          game.use_production_wheel(resource, token, self)

          self.save_all
          return
        end
      when SubturnActionCode::CHOOSE_CLERGY_MEMBER
        clergy_index = params[:game][:action_clergy_member].to_i
        mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)

        active_seat = self
        # This is the case if we're doing a work contract
        if game.action_seat.number != game.current_seat_number
          active_seat = game.find_seat_by_number(game.current_seat_number)
        end

        game.subturns << Subturn.new({
          :seat_id => self.id, 
          :timestamp => Time.now, 
          :actioncode => SubturnActionCode::CHOOSE_CLERGY_MEMBER,
          :parameters => clergy_index.to_s})
        game.action_seat = active_seat
        game.save

        case clergy_index
        when 0
          self.clergy0_location_x = mo[2].to_i
          self.clergy0_location_y = mo[3].to_i
        when 1
          self.clergy1_location_x = mo[2].to_i
          self.clergy1_location_y = mo[3].to_i
        when 2
          self.prior_location_seat = game.find_seat_by_number(mo[1].to_i)
          self.prior_location_x = mo[2].to_i
          self.prior_location_y = mo[3].to_i
        end
        self.save_all
        active_seat.enter_building(nil, game.find_seat_by_number(mo[1].to_i), mo[2].to_i, mo[3].to_i)

      when SubturnActionCode::DECIDE_ENTER_BUILDING
        if params[:game][:action_use_prior] == "Yes"
          mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
          game.subturns << Subturn.new({
            :seat_id => self.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::DECIDE_ENTER_BUILDING,
            :parameters => params[:game][:action_use_prior]})
          game.save

          self.prior_location_seat = self
          self.prior_location_x = mo[2].to_i
          self.prior_location_y = mo[3].to_i
          self.save_all
          enter_building(nil, game.find_seat_by_number(mo[1].to_i), mo[2].to_i, mo[3].to_i)
        else
          game.actioncode = nil
          game.save
        end

      when SubturnActionCode::CHOOSE_BUILDING_ACTION
        mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        if mo
          building = game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)
        else
          mo = game.subturns.last.parameters.match(/(\d+)/)
          building = BuildingCard.find(mo[1].to_i)
        end

        resource_spend = {}
        for res in Game::Resource.constants(false)
          res_key = Game::Resource.const_get(res)
          v = params[:game]["resource_spend_%s" % res_key].to_i
          next if v <= 0
          resource_spend[res_key] = v
        end
        for res in (params[:game][:resource_spend] || [])
          resource_spend[res.to_i] = 1
        end

        # New refactoring of CHOOSE_BUILDING_ACTION -- shoving things into the BuildingCard class
        is_success = building.resolve_action(game, self, 
          :action_0 => params[:game][:action_building_action_0].to_i, 
          :action_1 => params[:game][:action_building_action_1].to_i,
          :resource_spend => resource_spend,
          :resource_gain_0 => (params[:game][:resource_gain_0] || []).map{|r| r.to_i},
          :resource_gain_1 => (params[:game][:resource_gain_1] || []).map{|r| r.to_i},
          :resource_gain_2 => (params[:game][:resource_gain_2] || []).map{|r| r.to_i}
          )
        if is_success
          self.save_all
          game.actions_taken += 1 if game.actioncode == nil
          game.save
          return
        end

        binding.pry
        case building.key
        when "I03" # Granary
          convert = [self.res_coin, params[:game][:action_building_action].to_i].min
          if convert > 0
            self.res_coin -= 1
            self.res_grain += 4
            self.res_book += 1
            self.save_all
          end

          game.actioncode = nil
          game.actions_taken += 1
          game.save
        when "I04" # Malthouse
          convert = [self.res_grain, params[:game][:action_building_action].to_i].min
          self.res_grain -= convert
          self.res_malt += convert
          self.res_straw += convert
          self.save_all

          game.actioncode = nil
          game.actions_taken += 1
          game.save
        when "G07" # Peat Coal Kiln
          convert = [self.res_peat, params[:game][:action_building_action].to_i].min
          self.res_peat -= convert
          self.res_peatcoal += convert
          self.save_all

          game.actioncode = nil
          game.actions_taken += 1
          game.save
        when "G13" # Builders' Market
          convert = [self.res_coin, params[:game][:action_building_action].to_i].min
          if convert > 0
            self.add_resource(Resource::COIN, -2 * convert)
            self.add_resource(Resource::WOOD, 2 * convert)
            self.add_resource(Resource::CLAY, 2 * convert)
            self.add_resource(Resource::STONE, convert)
            self.add_resource(Resource::STRAW, convert)
            self.save_all
          end

          game.actioncode = nil
          game.actions_taken += 1
          game.save
        when "I17" # Scriptorium
          convert = [self.res_coin, params[:game][:action_building_action].to_i].min
          if convert > 0
            self.add_resource(Resource::COIN, -convert)
            self.add_resource(Resource::BOOK, convert)
            self.add_resource(Resource::MEAT, convert)
            self.add_resource(Resource::WHISKEY, convert)
            self.save_all
          end

          game.actioncode = nil
          game.actions_taken += 1
          game.save
        when "G19" # Slaughterhouse
          convert = [self.res_livestock, self.res_grain + self.res_straw, params[:game][:action_building_action].to_i].min
          if convert > 0
            self.add_resource(Resource::LIVESTOCK, -convert)
            self.add_resource(Resource::STRAW, -convert)
            self.add_resource(Resource::MEAT, convert)
            self.save_all
          end

          game.actioncode = nil
          game.actions_taken += 1
          game.save
        end

      when SubturnActionCode::PLACE_LANDSCAPE
        mo = game.subturns.last.parameters.match(/(.+):(\d+)/)
        if mo[1] == "District"
          district = District.find(mo[2].to_i)
          return if district == nil
          return if !self.districts.include?(district)
          return if district.position_x != nil
          district.side = params[:game][:action_landscape_side].to_i
          district.position_x = params[:game][:landscape_position_x].to_i
          district.position_y = params[:game][:landscape_position_y].to_i
          return if district.position_x != 100
          if district.side == District::Side::MFFHH
            district.tile0_type = Game::LocationType::PLAINS
            district.tile1_type = Game::LocationType::PLAINS
            district.tile2_type = Game::LocationType::PLAINS
            district.tile3_type = Game::LocationType::HILLSIDE
            district.tile4_type = Game::LocationType::HILLSIDE
            district.tile0 = BuildingCard.where(:key => 'R02').first
            district.tile1 = BuildingCard.where(:key => 'R01').first
            district.tile2 = BuildingCard.where(:key => 'R01').first
          elsif district.side == District::Side::FPPPH
            district.tile0_type = Game::LocationType::PLAINS
            district.tile1_type = Game::LocationType::PLAINS
            district.tile2_type = Game::LocationType::PLAINS
            district.tile3_type = Game::LocationType::PLAINS
            district.tile4_type = Game::LocationType::HILLSIDE
            district.tile0 = BuildingCard.where(:key => 'R01').first
          else
            return
          end
          district.save
        elsif mo[1] == "Plot"
          plot = Plot.find(mo[2].to_i)
          return if plot == nil
          return if !self.plots.include?(plot)
          return if plot.position_x != nil
          binding.pry
          plot.position_x = params[:game][:landscape_position_x].to_i
          plot.position_y = params[:game][:landscape_position_y].to_i
          plot.side = Plot::Side::WWCC if plot.position_x == 98
          plot.side = Plot::Side::HHM if plot.position_x == 105
          return if plot.position_x != 98 && plot.position_x != 105
          if plot.side == Plot::Side::WWCC
            plot.tile00_type = Game::LocationType::WATER
            plot.tile10_type = Game::LocationType::WATER
            plot.tile01_type = Game::LocationType::COAST
            plot.tile11_type = Game::LocationType::COAST
          elsif plot.side == Plot::Side::HHM
            plot.tile00_type = Game::LocationType::HILLSIDE
            plot.tile10_type = Game::LocationType::HILLSIDE
            plot.tile01_type = Game::LocationType::MOUNTAIN
            plot.tile11_type = nil
          else
            return
          end
          plot.save
        else
          return
        end
        case game.subturns.last.actioncode
        when SubturnActionCode::BUY_LANDSCAPE
          game.landscape_purchased = true
          game.subturns << Subturn.new({
            :seat_id => self.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::PLACE_LANDSCAPE,
            :parameters => "%s:%s,%s,%s" % [mo[1], params[:game][:landscape_position_x], params[:game][:landscape_position_y], params[:game][:action_landscape_side]]})
          game.actioncode = nil
          game.save
        when SubturnActionCode::GAIN_LANDSCAPE
          subturn = game.subturns.find_last_by_actioncode(SubturnActionCode::ENTER_BUILDING)
          mo_b = subturn.parameters.match(/(\d+):(\d+),(\d+)/)
          binding.pry
          if mo_b
            building = game.find_seat_by_number(mo_b[1].to_i).find_tile_by_location(mo_b[2].to_i, mo_b[3].to_i)
          else
            building = game.building_cards.find(subturn.parameters)
          end
          is_success = building.resolve_action(game, self)
          if is_success
            self.save_all
            game.save
            return
          end
        end

      when SubturnActionCode::CHOOSE_RESOURCES
        mo = game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        seat = game.find_seat_by_number(mo[1].to_i)
        case game.subturns.last.actioncode
        when SubturnActionCode::CHOOSE_BUILDING_ACTION, SubturnActionCode::CHOOSE_TILE_LOCATIONS
          building = seat.find_tile_by_location(mo[2].to_i, mo[3].to_i)

          resource_gain = {}
          for res in Game::Resource.constants(false)
            res_key = Game::Resource.const_get(res)
            v = params[:game]["resource_gain_%s" % res_key].to_i
            next if v <= 0
            resource_gain[res_key] = v
          end
          for res in (params[:game][:resource_gain] || [])
            resource_gain[res] = 1
          end

          is_success = building.resolve_action(game, self, 
            :resource_spend => params[:game][:resource_spend], 
            :resource_gain => resource_gain
            )
          if is_success
            self.save_all
            game.actions_taken += 1 if game.actioncode == nil
            game.save
            return
          end

          case building.key
          when /S.+/ # Settlements
            fuel_spent = 0
            food_spent = 0
            for res in Game::Resource.constants(false)
              res_key = Game::Resource.const_get(res)
              v = params[:game]["resource_spend_%s" % res_key].to_i
              next if v <= 0
              self.add_resource(res_key, -v)
              case res_key
              when Game::Resource::WOOD
                fuel_spent += v
              when Game::Resource::PEAT
                fuel_spent += 2*v
              when Game::Resource::STRAW
                fuel_spent += 0.5*v
              when Game::Resource::PEATCOAL
                fuel_spent += 3*v

              when Game::Resource::GRAIN, Game::Resource::COIN, Game::Resource::GRAPES, Game::Resource::MALT, Game::Resource::FLOUR, Game::Resource::WINE
                food_spent += v
              when Game::Resource::LIVESTOCK, Game::Resource::WHISKEY
                food_spent += 2*v
              when Game::Resource::COINX5, Game::Resource::MEAT, Game::Resource::BEER
                food_spent += 5*v
              when Game::Resource::BREAD
                food_spent += 3*v
              end
            end
            return if fuel_spent < building.cost_fuel || food_spent < building.cost_food
            self.save_all
            game.subturns << Subturn.new({
              :seat_id => self.id, 
              :timestamp => Time.now, 
              :actioncode => SubturnActionCode::CHOOSE_RESOURCES,
              :parameters => '%s:%s,%s' % [seat.number, mo[2].to_i, mo[3].to_i]})
            game.actioncode = nil
            game.actions_taken = 2
            game.save

          when "G06" # Fuel Merchant
            binding.pry
            fuel_spent = 0
            for res in Game::Resource.constants(false)
              res_key = Game::Resource.const_get(res)
              v = params[:game]["resource_spend_%s" % res_key].to_i
              next if v <= 0
              self.add_resource(res_key, -v)
              case res_key
              when Game::Resource::WOOD
                fuel_spent += v
              when Game::Resource::PEAT
                fuel_spent += 2*v
              when Game::Resource::STRAW
                fuel_spent += 0.5*v
              when Game::Resource::PEATCOAL
                fuel_spent += 3*v
              end
            end
            if fuel_spent >= 9
              self.add_resource(Game::Resource::COIN, 10)
            elsif fuel_spent >= 6
              self.add_resource(Game::Resource::COIN, 8)
            elsif fuel_spent >= 3
              self.add_resource(Game::Resource::COIN, 5)
            end
            self.save_all
            game.subturns << Subturn.new({
              :seat_id => self.id, 
              :timestamp => Time.now, 
              :actioncode => SubturnActionCode::CHOOSE_RESOURCES,
              :parameters => '%s:%s,%s' % [seat.number, mo[2].to_i, mo[3].to_i]})
            game.actioncode = nil
            game.actions_taken += 1
            game.save
          when "G12" # Stone Merchant
            binding.pry
          when "I14" # Sacred Site
            binding.pry
          end
        when SubturnActionCode::WORK_CONTRACT
          return if params[:game][:resource_spend].length != 1
          res = params[:game][:resource_spend][0].to_i
          case res
          when Resource::COIN
            return if self.res_coin + 5*self.res_5coin < game.work_contract_price
            self.add_resource(Resource::COIN, -game.work_contract_price)
            self.save_all
            seat.add_resource(Resource::COIN, game.work_contract_price)
            seat.save_all
          when Resource::WHISKEY, Resource::WINE
            return if self.get_resource(res) <= 0
            self.add_resource(res, -1)
            self.save_all
          else
            return
          end
          params[:game][:action_types] = "205"
          params[:game][:action_contract] = "205:%s" % game.subturns.last.parameters
          params[:game][:contract_paid] = true
          self.perform_action(params)
        end
      when SubturnActionCode::CONVERT_RESOURCES
        convert = ''
        for res in Game::Resource.constants(false)
          res_key = Game::Resource.const_get(res)
          v = params[:game]["resource_spend_%s" % res_key].to_i
          next if v <= 0
          case res_key
          when Resource::GRAIN
            self.add_resource(Resource::GRAIN, -v)
            self.add_resource(Resource::STRAW, v)
            convert += "%sGrain:%s" % [(convert.length > 0 ? "," : ""), v]
          when Resource::WHISKEY
            self.add_resource(Resource::WHISKEY, -v)
            self.add_resource(Resource::COIN, 2*v)
            convert += "%sWhiskey:%s" % [(convert.length > 0 ? "," : ""), v]
          when Resource::WINE
            self.add_resource(Resource::WINE, -v)
            self.add_resource(Resource::COIN, v)
            convert += "%sWine:%s" % [(convert.length > 0 ? "," : ""), v]
          end
        end
        if convert.length > 0
          game.subturns << Subturn.new({
            :seat_id => self.id, 
            :timestamp => Time.now, 
            :actioncode => SubturnActionCode::CONVERT_RESOURCES,
            :parameters => convert})
        end
        game.actioncode = nil
        self.save_all
        game.save
      end
    end
  end

  def enter_building(tile=nil, seat=nil, x=nil, y=nil)

    if tile == nil
      tile = seat.find_tile_by_location(x, y)
      return if tile == nil

      param = '%s:%s,%s' % [seat.number, x, y]
    else
      param = tile.id
    end

    case tile.key
    # Clay mound, Farmyard, Cloister Office, Quarry
    when "H01", "H02", "H03", "G22"
      game.subturns << Subturn.new({
        :seat_id => self.id, 
        :timestamp => Time.now, 
        :actioncode => SubturnActionCode::CHOOSE_TILE_LOCATIONS,
        :parameters => param})
      game.actioncode = SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
      game.save
    # PrioryGrand Manor, Forest Hut, Guesthouse
    when "G01", "I27", "I29", "I40" 
      self.save_all
      game.subturns << Subturn.new({
        :seat_id => self.id, 
        :timestamp => Time.now, 
        :actioncode => SubturnActionCode::ENTER_BUILDING,
        :parameters => param})
      game.actioncode = SubturnActionCode::CHOOSE_TILE_LOCATIONS
      game.save
    # Cloister Courtyard, Granary, Malthouse, Brewery, Fuel Merchant, Peat Coal Kiln, False Lighthouse, 
    # Stone Merchant, Builders' Market, Sacred Site, Druid's House, Scriptorium, Cloister Workshop, Slaughterhouse,
    # Alehouse, Whiskey Distillery, Locutory, Chapel, Portico, Shipyard, Refectory, Coal Harbor, Filial Church,
    # Cooperage, Sacristy, Round Tower, Camera, Bulwark, Festival Ground, Estate, House of the Brotherhood
    when "G02", "I03", "I04", "I05", "G06", "G07", "I08", "G12", "G13", "I14", "I15", "I17", "G18", "G19", "I20", 
        "I21", "I23", "I24", "I25", "G26", "I30", "I31", "I32", "I33", "G34", "I35", "I36", "I37", "I38", "I39", 
        "G41"
      self.save_all
      game.subturns << Subturn.new({
        :seat_id => self.id, 
        :timestamp => Time.now, 
        :actioncode => SubturnActionCode::ENTER_BUILDING,
        :parameters => param})
      game.actioncode = SubturnActionCode::CHOOSE_BUILDING_ACTION
      game.save
    # Spinning Mill, Cottage, Houseboat, Cloister Chapter House
    when "I09", "I10", "I11", "G16"
      tile.resolve_action(game, self, :parameters => '%s:%s,%s' % [seat.number, x, y])
      self.save_all
      game.subturns << Subturn.new({
        :seat_id => self.id, 
        :timestamp => Time.now, 
        :actioncode => SubturnActionCode::ENTER_BUILDING,
        :parameters => param})
      game.actioncode = nil
      game.actions_taken += 1
      game.save
    # Castle
    when "G28"
      self.save_all
      game.subturns << Subturn.new({
        :seat_id => self.id, 
        :timestamp => Time.now, 
        :actioncode => SubturnActionCode::ENTER_BUILDING,
        :parameters => param})
      game.actioncode = SubturnActionCode::BUILD_BUILDING
      game.save
    end
  end
end