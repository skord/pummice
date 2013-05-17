class GamesController < ApplicationController

  # This section tells Devise that these actions require a user to be authenticated first
  # Viewing all games and viewing a particular game do not require a user to be signed in
  before_filter :authenticate_user!, :only => [:create, :join, :new, :update]

  helper_method :start_game

  def index
    @current_user = current_user
    if params[:started] == 'n'
      @games = Game.pending_users
    elsif params[:all] == 'y'
      @games = Game.active
    elsif current_user != nil
      @games = Game.where('round > 0').joins('LEFT OUTER JOIN seats on seats.game_id = games.id').where('seats.user_id = ?', current_user.id)
    else
      @games = []
    end
  end

  def show
    @game = Game.find(params[:id])
    @current_seat = @game.action_seat

    @display_grid = {}
    @select_tiles = {}
    @scores = {}

    for seat in @game.seats
      @scores[seat.number] = seat.get_score
      @select_tiles[seat.number] = []

      # Plot Left, Heartland/District, Plot Right
      @display_grid[seat.number] = [[], [], []]
      @paintable_locations = [];
      mins = [-1] * 3
      previous_y = 0
      for plot in seat.plots_left
        mins[0] = plot.position_y if mins[0] < 0
        if previous_y > 0 && previous_y + 2 != plot.position_y
          @display_grid[seat.number][0] += [nil] * (plot.position_y - previous_y - 2)
        end
        @display_grid[seat.number][0] << plot
        @display_grid[seat.number][0] << "spacer"
        previous_y = plot.position_y
      end
      for district in seat.districts_above
        mins[1] = district.position_y if mins[1] < 0
        @display_grid[seat.number][1] << district
      end
      @display_grid[seat.number][1] << seat
      @display_grid[seat.number][1] << HeartlandSpacer.new(seat.heartland_position_x, seat.heartland_position_y+1)
      for district in seat.districts_below
        @display_grid[seat.number][1] << district
      end
      previous_y = 0
      for plot in seat.plots_right
        mins[2] = plot.position_y if mins[2] < 0
        if previous_y > 0 && previous_y + 2 != plot.position_y
          @display_grid[seat.number][2] += [nil] * (plot.position_y - previous_y - 2)
        end
        @display_grid[seat.number][2] << plot
        @display_grid[seat.number][2] << "spacer"
        previous_y = plot.position_y
      end
      for i in 0.step(2)
        mins[i] = seat.heartland_position_y if mins[i] < 0
      end

      #binding.pry
      if mins.min != mins[0]
        @display_grid[seat.number][0] = [nil] * (mins[0] - mins.min) + @display_grid[seat.number][0]
      end
      if mins.min != mins[1]
        @display_grid[seat.number][1] = [nil] * (mins[1] - mins.min) + @display_grid[seat.number][1]
      end
      if mins.min != mins[2]
        @display_grid[seat.number][2] = [nil] * (mins[2] - mins.min) + @display_grid[seat.number][2]
      end
      lens = @display_grid[seat.number].map{|x| x.length}
      @display_grid[seat.number][0] += [nil] * (lens.max - @display_grid[seat.number][0].length)
      @display_grid[seat.number][1] += [nil] * (lens.max - @display_grid[seat.number][1].length)
      @display_grid[seat.number][2] += [nil] * (lens.max - @display_grid[seat.number][2].length)

    end

    @select_tile_count = 0
    @select_tokens = []
    @select_token_count = 0
    @clergy_members = []
    @building_card = nil
    @build_building = []
    @landscape = nil

    @resource_mode = 0
    @resource_spend = {}
    @resource_spend_count = 0
    @resource_convert_max = 0
    @resource_gain = {}
    @resource_gain_multiplier = 1
    @resource_gain_unique = false
    @resource_gain_max = 0
    @resource_options = []
    @resource_needed = {}
    @activities = {}

    if @game.action_seat && @game.action_seat.user == @current_user
      case @game.actioncode
      when Subturn::SubturnActionCode::CHOOSE_TILE_LOCATIONS
        if @game.subturns.last
          case @game.subturns.last.actioncode
          when Subturn::SubturnActionCode::FELL_TREES
            @select_tiles[@game.action_seat.number] = @game.action_seat.find_building_locations_by_lambda(->(t){ t.key == "R01" })
            #find_building_locations_by_key("R01")
            @select_tile_count = 1
          when Subturn::SubturnActionCode::CUT_PEAT
            @select_tiles[@game.action_seat.number] = @game.action_seat.find_building_locations_by_lambda(->(t){ t.key == "R02" })
            #find_building_locations_by_key("R02")
            @select_tile_count = 1
          when Subturn::SubturnActionCode::BUILD_BUILDING
            @building_card = BuildingCard.find(@game.subturns.last.parameters.to_i)
            @select_tiles[@game.action_seat.number] = @game.action_seat.find_allowable_tile_locations(@building_card)
            @select_tile_count = 1
          when Subturn::SubturnActionCode::ENTER_BUILDING
            mo = @game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
            tileSeat = @game.find_seat_by_number(mo[1].to_i)
            case tileSeat.find_tile_by_location(mo[2].to_i, mo[3].to_i).key
            when "G01" # Priory
              for seat in @game.seats
                @select_tiles[seat.number] << [seat.prior_location_x, seat.prior_location_y] if seat.prior_location_x > 0 && 
                  !(seat == @game.action_seat && seat.prior_location_x == mo[2].to_i && seat.prior_location_y == mo[3].to_i)
              end
              @select_tile_count = 1
            when "I10" # Cottage
              for xy in [[-1, 0], [1, 0], [0, -1], [0, 1]]
                x = mo[2].to_i + xy.first
                y = mo[3].to_i + xy.last
                adjTile = tileSeat.find_tile_by_location(x, y)
                next if !adjTile
                next if tileSeat.prior_location_x == x && tileSeat.prior_location_y == y && tileSeat.prior_location_seat == tileSeat
                next if tileSeat.clergy0_location_x == x && tileSeat.clergy0_location_y == y
                next if tileSeat.clergy1_location_x == x && tileSeat.clergy1_location_y == y
                @select_tiles[tileSeat.number] << [x, y]
              end
              @select_tile_count = 1
            when "I27" # Grand Manor
              for seat in @game.seats
                @select_tiles[seat.number] << [seat.prior_location_x, seat.prior_location_y] if seat.prior_location_x > 0 && 
                  !(seat == @game.action_seat && seat.prior_location_x == mo[2].to_i && seat.prior_location_y == mo[3].to_i)
                @select_tiles[seat.number] << [seat.clergy0_location_x, seat.clergy0_location_y] if seat.clergy0_location_x > 0 && 
                  !(seat == @game.action_seat && seat.clergy0_location_x == mo[2].to_i && seat.clergy0_location_y == mo[3].to_i)
                @select_tiles[seat.number] << [seat.clergy1_location_x, seat.clergy1_location_y] if seat.clergy1_location_x > 0 && 
                  !(seat == @game.action_seat && seat.clergy1_location_x == mo[2].to_i && seat.clergy1_location_y == mo[3].to_i)
              end
              @select_tile_count = 1
            when "I29" # Forest Hut
              @select_tiles[@game.action_seat.number] = @game.action_seat.find_building_locations_by_lambda(->(t){ t.key == "R01" })
              #find_building_locations_by_key("R01")
              @select_tile_count = 1
            when "I40" # Guesthouse
              @select_tiles[0] = []
              for building_card in @game.building_cards
                @select_tiles[0] << building_card
              end
              @select_tile_count = 1
            end
          end
        end

      when Subturn::SubturnActionCode::CHOOSE_PRODUCTION_TOKENS
        if @game.subturns.last
          # case @game.subturns.last.actioncode
          # when Subturn::SubturnActionCode::CHOOSE_TILE_LOCATIONS
          mo = @game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
          case @game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i).key
          when "R01"
            @select_tokens = {Resource::WOOD => Token::WOOD|Token::JOKER}
            @select_token_count = 1
          when "R02"
            @select_tokens = {Resource::PEAT => Token::PEAT|Token::JOKER}
            @select_token_count = 1
          when "H01"
            @select_tokens = {Resource::CLAY => Token::CLAY|Token::JOKER}
            @select_token_count = 1
          when "H02"
            @select_tokens = {
              Resource::GRAIN => Token::GRAIN|Token::JOKER, 
              Resource::LIVESTOCK => Token::LIVESTOCK|Token::JOKER
            }
            @select_token_count = 1
          when "H03"
            @select_tokens = {Resource::COIN => Token::COIN|Token::JOKER}
            @select_token_count = 1
          when "G22"
            @select_tokens = {Resource::STONE => Token::STONE|Token::JOKER}
            @select_token_count = 1
          when "I33"
            @select_tokens = {
              Resource::BEER => Token::JOKER, 
              Resource::WHISKEY => Token::JOKER
            }
            @select_token_count = 1
          when "F33"
            @select_tokens = {
              Resource::MEAT => Token::JOKER, 
              Resource::BREAD => Token::JOKER, 
              Resource::WINE => Token::JOKER
            }
            @select_token_count = 1
          end
          #end
        end

      when Subturn::SubturnActionCode::CHOOSE_CLERGY_MEMBER
        @clergy_members << ["Laybrother", 0] if @game.action_seat.clergy0_location_x == 0
        @clergy_members << ["Laybrother", 1] if @game.action_seat.clergy0_location_x > 0 && @game.action_seat.clergy1_location_x == 0
        @clergy_members << ["Prior", 2] if @game.action_seat.prior_location_x == 0
        mo = @game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        @building_card = @game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)

      when Subturn::SubturnActionCode::DECIDE_ENTER_BUILDING
        mo = @game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        @building_card = @game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)

      when Subturn::SubturnActionCode::CHOOSE_BUILDING_ACTION
        mo = @game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        if mo
          @building_card = @game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)
        else
          mo = @game.subturns.last.parameters.match(/(\d+)/)
          @building_card = BuildingCard.find(mo[1].to_i)
        end
        @activities = @building_card.action_for_game_controller(@current_seat)

      when Subturn::SubturnActionCode::PLACE_LANDSCAPE
        mo = @game.subturns.last.parameters.match(/(.+):(\d+)/)
        if mo[1] == "District"
          @landscape = District.find(mo[2].to_i)

          if ![0, nil].include?(@display_grid[@game.action_seat.number][1][0])
            @display_grid[@game.action_seat.number][0].insert(0, nil)
            @display_grid[@game.action_seat.number][1].insert(0, nil)
            @display_grid[@game.action_seat.number][2].insert(0, nil)
            mins[0] -= 1
          end
          if ![0, nil].include?(@display_grid[@game.action_seat.number][1][-1])
            @display_grid[@game.action_seat.number][0] << nil
            @display_grid[@game.action_seat.number][1] << nil
            @display_grid[@game.action_seat.number][2] << nil
          end
          ind = @display_grid[@game.action_seat.number][1].index{|t| ![0, nil].include?(t)}
          @display_grid[@game.action_seat.number][1][ind-1] = @display_grid[@game.action_seat.number][1][ind].position_y - 1 if ind > 0
          ind = @display_grid[@game.action_seat.number][1].rindex{|t| ![0, nil].include?(t)}
          @display_grid[@game.action_seat.number][1][ind+1] = @display_grid[@game.action_seat.number][1][ind].position_y + 1 if ind < @display_grid[@game.action_seat.number][1].length
        else
          @landscape = Plot.find(mo[2].to_i)

          for c in 0.step(2,2)
            if ![0, nil].include?(@display_grid[@game.action_seat.number][c][1])
              if ![0, nil].include?(@display_grid[@game.action_seat.number][c][0])
                @display_grid[@game.action_seat.number][0].insert(0, nil)
                @display_grid[@game.action_seat.number][1].insert(0, nil)
                @display_grid[@game.action_seat.number][2].insert(0, nil)
                mins[0] -= 1
              end
              @display_grid[@game.action_seat.number][0].insert(0, nil)
              @display_grid[@game.action_seat.number][1].insert(0, nil)
              @display_grid[@game.action_seat.number][2].insert(0, nil)
              mins[0] -= 1
            end
            if ![0, nil].include?(@display_grid[@game.action_seat.number][c][-2])
              if ![0, nil].include?(@display_grid[@game.action_seat.number][c][-1])
                @display_grid[@game.action_seat.number][0] << nil
                @display_grid[@game.action_seat.number][1] << nil
                @display_grid[@game.action_seat.number][2] << nil
              end
              @display_grid[@game.action_seat.number][0] << nil
              @display_grid[@game.action_seat.number][1] << nil
              @display_grid[@game.action_seat.number][2] << nil
            end
            if ![0, nil].include?(@display_grid[@game.action_seat.number][1][0])
              @display_grid[@game.action_seat.number][0].insert(0, nil)
              @display_grid[@game.action_seat.number][1].insert(0, nil)
              @display_grid[@game.action_seat.number][2].insert(0, nil)
              mins[0] -= 1
            end
            if ![0, nil].include?(@display_grid[@game.action_seat.number][1][-1])
              @display_grid[@game.action_seat.number][0] << nil
              @display_grid[@game.action_seat.number][1] << nil
              @display_grid[@game.action_seat.number][2] << nil
            end
            for x in 0.step(@display_grid[@game.action_seat.number][c].length - 2)
              if (@display_grid[@game.action_seat.number][c][x] == nil || (@display_grid[@game.action_seat.number][c][x].is_a?(Integer) && @display_grid[@game.action_seat.number][c][x] < 0)) && 
                  @display_grid[@game.action_seat.number][c][x+1] == nil &&
                  (@display_grid[@game.action_seat.number][1][x] != nil || 
                    @display_grid[@game.action_seat.number][1][x+1] != nil || 
                    (@display_grid[@game.action_seat.number][c][x-1] != nil && 
                    !@display_grid[@game.action_seat.number][c][x-1].is_a?(Integer)) ||
                    @display_grid[@game.action_seat.number][c][x+2] != nil)
                @display_grid[@game.action_seat.number][c][x] = mins[0] + x
                @display_grid[@game.action_seat.number][c][x+1] = -(mins[0] + x + 1)
                if !@paintable_locations.include?("%s%s" % [c == 0 ? "0" : "1", mins[0] + x])
                  @paintable_locations << "%s%s" % [c == 0 ? "0" : "1", mins[0] + x]
                end
                @paintable_locations << "%s%s" % [c == 0 ? "0" : "1", mins[0] + x + 1]
              end
            end
          end
        end

      when Subturn::SubturnActionCode::CHOOSE_RESOURCES
        mo = @game.subturns.last.parameters.match(/(\d+):(\d+),(\d+)/)
        case @game.subturns.last.actioncode
        when SubturnActionCode::CHOOSE_BUILDING_ACTION, SubturnActionCode::CHOOSE_TILE_LOCATIONS
          @building_card = @game.find_seat_by_number(mo[1].to_i).find_tile_by_location(mo[2].to_i, mo[3].to_i)
          case @building_card.key
          when /S.+/ # Settlements
            @resource_mode = SubturnResourceMode::FUEL_FOOD
            # Fuels
            @resource_spend[:fuel] = {}
            @resource_spend[:fuel][Resource::WOOD] = @current_seat.res_wood if @current_seat.res_wood > 0
            @resource_spend[:fuel][Resource::PEAT] = @current_seat.res_peat if @current_seat.res_peat > 0
            @resource_spend[:fuel][Resource::PEATCOAL] = @current_seat.res_peatcoal if @current_seat.res_peatcoal > 0
            @resource_spend[:fuel][Resource::STRAW] = @current_seat.res_straw + @current_seat.res_grain if @current_seat.res_straw > 0 || @current_seat.res_grain > 0
            # Foods
            @resource_spend[:food] = {}
            @resource_spend[:food][Resource::GRAIN] = @current_seat.res_grain if @current_seat.res_grain > 0
            @resource_spend[:food][Resource::LIVESTOCK] = @current_seat.res_livestock if @current_seat.res_livestock > 0
            @resource_spend[:food][Resource::COIN] = @current_seat.res_coin + @current_seat.res_5coin * 5 if @current_seat.res_coin + @current_seat.res_5coin > 0
            @resource_spend[:food][Resource::GRAPES] = @current_seat.res_grapes if @current_seat.res_grapes > 0
            @resource_spend[:food][Resource::MALT] = @current_seat.res_malt if @current_seat.res_malt > 0
            @resource_spend[:food][Resource::FLOUR] = @current_seat.res_flour if @current_seat.res_flour > 0
            @resource_spend[:food][Resource::WHISKEY] = @current_seat.res_whiskey if @current_seat.res_whiskey > 0
            @resource_spend[:food][Resource::MEAT] = @current_seat.res_meat if @current_seat.res_meat > 0
            @resource_spend[:food][Resource::WINE] = @current_seat.res_wine if @current_seat.res_wine > 0
            @resource_spend[:food][Resource::BEER] = @current_seat.res_beer if @current_seat.res_beer > 0
            @resource_spend[:food][Resource::BREAD] = @current_seat.res_bread if @current_seat.res_bread > 0

            @resource_needed[:fuel] = @building_card.cost_fuel
            @resource_needed[:food] = @building_card.cost_food
          # when "G02" # Cloister Courtyard
          #   @resource_mode = SubturnResourceMode::UNIQUES
          #   @resource_spend[Resource::WOOD] = 1 if @current_seat.res_wood > 0
          #   @resource_spend[Resource::PEAT] = 1 if @current_seat.res_peat > 0
          #   @resource_spend[Resource::GRAIN] = 1 if @current_seat.res_grain > 0
          #   @resource_spend[Resource::LIVESTOCK] = 1 if @current_seat.res_livestock > 0
          #   @resource_spend[Resource::CLAY] = 1 if @current_seat.res_clay > 0
          #   @resource_spend[Resource::COIN] = 1 if @current_seat.res_coin > 0 || @current_seat.res_5coin > 1 || @current_seat.res_whiskey > 1 || @current_seat.res_wine > 1
          #   @resource_spend[Resource::COINX5] = 1 if @current_seat.res_5coin > 0
          #   @resource_spend[Resource::STONE] = 1 if @current_seat.res_stone > 0
          #   @resource_spend[Resource::GRAPES] = 1 if @current_seat.res_grapes > 0
          #   @resource_spend[Resource::MALT] = 1 if @current_seat.res_malt > 0
          #   @resource_spend[Resource::FLOUR] = 1 if @current_seat.res_flour > 0
          #   @resource_spend[Resource::WHISKEY] = 1 if @current_seat.res_whiskey > 0
          #   @resource_spend[Resource::PEATCOAL] = 1 if @current_seat.res_peatcoal > 0
          #   @resource_spend[Resource::STRAW] = 1 if @current_seat.res_straw > 0 || @current_seat.res_grain > 1
          #   @resource_spend[Resource::MEAT] = 1 if @current_seat.res_meat > 0
          #   @resource_spend[Resource::CERAMIC] = 1 if @current_seat.res_ceramic > 0
          #   @resource_spend[Resource::BOOK] = 1 if @current_seat.res_book > 0
          #   @resource_spend[Resource::RELIQUERY] = 1 if @current_seat.res_reliquery > 0
          #   @resource_spend[Resource::ORNAMENT] = 1 if @current_seat.res_ornament > 0
          #   @resource_spend[Resource::WINE] = 1 if @current_seat.res_wine > 0
          #   @resource_spend[Resource::BEER] = 1 if @current_seat.res_beer > 0
          #   @resource_spend[Resource::BREAD] = 1 if @current_seat.res_bread > 0
          #   @resource_spend[Resource::WONDER] = 1 if @current_seat.res_wonder > 0
          #   @resource_spend_count = 3

          #   @resource_convert_max = 1

          #   @resource_gain[Resource::WOOD] = 1
          #   @resource_gain[Resource::PEAT] = 1
          #   @resource_gain[Resource::GRAIN] = 1
          #   @resource_gain[Resource::LIVESTOCK] = 1
          #   @resource_gain[Resource::CLAY] = 1
          #   @resource_gain[Resource::COIN] = 1
          #   @resource_gain_multiplier = [6]
          # when "G06" # Fuel Merchant
          #   @resource_mode = SubturnResourceMode::FUEL_FOOD
          #   @resource_spend[:fuel] = {}
          #   @resource_spend[:fuel][Resource::WOOD] = @current_seat.res_wood if @current_seat.res_wood > 0
          #   @resource_spend[:fuel][Resource::PEAT] = @current_seat.res_peat if @current_seat.res_peat > 0
          #   @resource_spend[:fuel][Resource::PEATCOAL] = @current_seat.res_peatcoal if @current_seat.res_peatcoal > 0
          #   @resource_spend[:fuel][Resource::STRAW] = @current_seat.res_straw + @current_seat.res_grain if @current_seat.res_straw > 0 || @current_seat.res_grain > 0

          #   @resource_gain[Resource::COIN] = [[[0, 0], 0], [[3, 0], 5], [[6, 0], 8], [[9, 0], 10]]
          # when "I08" # False Lighthouse
          #   binding.pry
          #   @resource_mode = SubturnResourceMode::OPTIONS
          #   @resource_options << {Resource::COIN => 3}
          #   @resource_options << {Resource::BEER => 1, Resource::WHISKEY => 1}
          # when "G12" # Stone Merchant
          #   @resource_mode = SubturnResourceMode::FUEL_FOOD
          #   # Fuels
          #   @resource_spend[:fuel] = {}
          #   @resource_spend[:fuel][Resource::WOOD] = @current_seat.res_wood if @current_seat.res_wood > 0
          #   @resource_spend[:fuel][Resource::PEAT] = @current_seat.res_peat if @current_seat.res_peat > 0
          #   @resource_spend[:fuel][Resource::PEATCOAL] = @current_seat.res_peatcoal if @current_seat.res_peatcoal > 0
          #   @resource_spend[:fuel][Resource::STRAW] = @current_seat.res_straw + @current_seat.res_grain if @current_seat.res_straw > 0 || @current_seat.res_grain > 0
          #   # Foods
          #   @resource_spend[:food] = {}
          #   @resource_spend[:food][Resource::GRAIN] = @current_seat.res_grain if @current_seat.res_grain > 0
          #   @resource_spend[:food][Resource::LIVESTOCK] = @current_seat.res_livestock if @current_seat.res_livestock > 0
          #   @resource_spend[:food][Resource::COIN] = @current_seat.res_coin + @current_seat.res_5coin * 5 if @current_seat.res_coin + @current_seat.res_5coin > 0
          #   @resource_spend[:food][Resource::GRAPES] = @current_seat.res_grapes if @current_seat.res_grapes > 0
          #   @resource_spend[:food][Resource::MALT] = @current_seat.res_malt if @current_seat.res_malt > 0
          #   @resource_spend[:food][Resource::FLOUR] = @current_seat.res_flour if @current_seat.res_flour > 0
          #   @resource_spend[:food][Resource::WHISKEY] = @current_seat.res_whiskey if @current_seat.res_whiskey > 0
          #   @resource_spend[:food][Resource::MEAT] = @current_seat.res_meat if @current_seat.res_meat > 0
          #   @resource_spend[:food][Resource::WINE] = @current_seat.res_wine if @current_seat.res_wine > 0
          #   @resource_spend[:food][Resource::BEER] = @current_seat.res_beer if @current_seat.res_beer > 0
          #   @resource_spend[:food][Resource::BREAD] = @current_seat.res_bread if @current_seat.res_bread > 0

          #   @resource_gain[Resource::STONE] = 0.step(5).map{|x| [[x, 2*x], x]}
          # when "I14" # Sacred Site
          #   @resource_mode = SubturnResourceMode::OPTIONS
          #   @resource_options << {Resource::BOOK => 1}
          #   @resource_options << {Resource::GRAIN => 2, Resource::MALT => 2}
          #   @resource_options << {Resource::BEER => 1, Resource::WHISKEY => 1}
          # when "I15" # Druid's House
          #   @resource_mode = SubturnResourceMode::UNIQUES
          #   @resource_spend[Resource::BOOK] = 1 if @current_seat.res_book > 0
          #   @resource_convert_max = 1

          #   @resource_gain[Resource::WOOD] = 1
          #   @resource_gain[Resource::PEAT] = 1
          #   @resource_gain[Resource::GRAIN] = 1
          #   @resource_gain[Resource::LIVESTOCK] = 1
          #   @resource_gain[Resource::CLAY] = 1
          #   @resource_gain[Resource::COIN] = 1
          #   @resource_gain_multiplier = [5, 3]
          #   @resource_gain_unique = true
          when "I38" # Festival Ground
            @resource_mode = SubturnResourceMode::VPS
            @resource_gain[Resource::BOOK] = 2
            @resource_gain[Resource::CERAMIC] = 3
            @resource_gain[Resource::ORNAMENT] = 4
            @resource_gain[Resource::RELIQUERY] = 8
            @resource_gain_max = @current_seat.find_building_locations_by_lambda(->(t){ ["R01","R02"].include?(t.key) }).count
            #find_building_locations_by_key("R01").count + @current_seat.find_building_locations_by_key("R02").count
          when "G41" # House of the Brotherhood
            @resource_mode = SubturnResourceMode::VPS
            @resource_gain[Resource::BOOK] = 2
            @resource_gain[Resource::CERAMIC] = 3
            @resource_gain[Resource::ORNAMENT] = 4
            @resource_gain[Resource::RELIQUERY] = 8
            @resource_gain_max = 2 * @current_seat.find_building_locations_by_lambda(->(t){ t.is_cloister }).count
          end
        when SubturnActionCode::WORK_CONTRACT
          @resource_mode = SubturnResourceMode::SPEND_CHOICES
          @resource_spend[Resource::COIN] = [@game.work_contract_price, @game.find_seat_by_number(mo[1].to_i).user.fullname]
          @resource_spend[Resource::WHISKEY] = [1, 'the bank'] if @current_seat.res_whiskey > 0
          @resource_spend[Resource::WINE] = [1, 'the bank'] if @current_seat.res_wine > 0
        end

      when Subturn::SubturnActionCode::BUILD_BUILDING
        @build_building = @game.action_seat.available_build(Phase::SETTLEMENT)

      when Subturn::SubturnActionCode::CONVERT_RESOURCES
        @activities[0] = [Resource::GRAIN, @current_seat.res_grain, Resource::STRAW, 1] if @current_seat.res_grain > 0
        @activities[1] = [Resource::WHISKEY, @current_seat.res_whiskey, Resource::COIN, 2] if @current_seat.res_whiskey > 0
        @activities[2] = [Resource::WINE, @current_seat.res_wine, Resource::COIN, 1] if @current_seat.res_wine > 0
      end
    end
  end

  def join
    @game = Game.find(params[:id])
    @game.users << current_user
  end

  def update
    @game = Game.find(params[:id])

    # This indicates the current user isn't in the game and is joining it
    if !@game.users.include?(current_user)
      @game.users << current_user
      if @game.users.count == @game.number_of_players
        start_game
      end
    end

    case params[:commit]
    when "Post message"
      if params[:chatlog][:message].strip != ""
        @game.chatlogs << Chatlog.new({
          :seat_id => @game.find_seat_by_user(current_user).id, 
          :timestamp => Time.now, 
          :message => params[:chatlog][:message]})
      end
    when "Play"
      if current_user = @game.action_seat.user
        @game.action_seat.perform_action(params)
      end
    end

    redirect_to game_path(@game)
  end

  def create
    if params[:game][:variant] == GameVariant::IRELAND and params[:game][:use_loamy_landscape]
      params[:game][:use_loamy_landscape] = false
    end

    if params[:game][:number_of_players] == 1
      params[:game][:is_short_game] = false
    end

    @game = Game.new(params[:game])
    if @game.save
      @game.users << current_user

      if @game.users.count == @game.number_of_players
        start_game
      end

      redirect_to game_path(@game)
    else
      flash[:notice] = "We couldn't create your game because you suck"
      render :new
    end
  end

  def new
  	@game = Game.new
  end

  def start_game
    # Game's setup of Plots, Districts, etc.
    district_costs = [2, 3, 4, 4, 5, 5, 6, 7, 8]
    plot_costs = [3, 4, 4, 5, 5, 5, 6, 6, 7]

    @game.age = Age::START
    @game.phase = Phase::NORMAL
    @game.round = 0  # When 'round' is > 0, that means the game has started
    @game.turn = 1

    @game.wheel_position = 1
    @game.wheel_wood_position = 1
    @game.wheel_peat_position = 1
    @game.wheel_grain_position = 1
    @game.wheel_livestock_position = 1
    @game.wheel_clay_position = 1
    @game.wheel_coin_position = 1
    @game.wheel_joker_position = 1

    card_where_clause = {:age => Age::START, :variant => @game.variant, :nop => @game.card_players}
    case @game.number_of_players
    when 1
      district_costs.reverse!
      plot_costs.reverse!
      @game.wheel_type = WheelType::ONE_TWO_PLAYER
      @game.wheel_house_position = 13
    when 2
      if @game.is_short_game
        @game.wheel_type = WheelType::ONE_TWO_PLAYER
      else
        @game.wheel_type = WheelType::TWO_PLAYER_LONG
      end
      @game.wheel_house_position = 8
    when 3
      if @game.is_short_game
        @game.wheel_type = WheelType::THREE_FOUR_PLAYER_SHORT
        @game.wheel_house_position = 4
      else
        @game.wheel_type = WheelType::THREE_PLAYER
        @game.wheel_house_position = 7
      end
    when 4
      if @game.is_short_game
        @game.wheel_type = WheelType::THREE_FOUR_PLAYER_SHORT
        @game.wheel_house_position = 4
      else
        @game.wheel_type = WheelType::FOUR_PLAYER
        @game.wheel_house_position = 8
      end
    end
    @game.building_cards = BuildingCard.where(
      'age = :age AND is_base = false AND variant IN (0, :variant) AND (number_players & :nop) = :nop', 
      card_where_clause)

    district_costs.each do |district_cost|
      @game.districts << District.new({:cost => district_cost})
    end

    plot_costs.each do |plot_cost|
      @game.plots << Plot.new({:cost => plot_cost})
    end

    # TODO :: In the single player game, there is a dummy/neutral player
    # that gets set up as well with different stuff.  This needs to be
    # done some way.

    # Set up initial board & resource stuff for the players
    seating = 1.step(@game.number_of_players).to_a.shuffle
    @game.actioncode = nil
    @game.seats.each do |seat|
      seat.number = seating[@game.seats.index(seat)]

      if @game.number_of_players.between?(3, 4) and @game.is_short_game
        seat.clergy1_location_x = nil
        seat.clergy1_location_y = nil
      else
        seat.tile00 = BuildingCard.where(:key => 'R02').first
        seat.tile01 = BuildingCard.where(:key => 'R01').first
      end

      seat.tile02 = BuildingCard.where(:key => 'R01').first
      seat.tile04 = BuildingCard.where(:key => 'H01').first
      seat.tile10 = BuildingCard.where(:key => 'R02').first
      seat.tile11 = BuildingCard.where(:key => 'R01').first
      seat.tile12 = BuildingCard.where(:key => 'H02').first
      seat.tile14 = BuildingCard.where(:key => 'H03').first

      seat.settlement0 = BuildingCard.where(:key => 'S01').first
      seat.settlement1 = BuildingCard.where(:key => 'S02').first
      seat.settlement2 = BuildingCard.where(:key => 'S03').first
      seat.settlement3 = BuildingCard.where(:key => 'S04').first

      if @game.number_of_players != 1
        seat.res_peat = 1
        seat.res_livestock = 1
        seat.res_grain = 1
        seat.res_wood = 1
        seat.res_clay = 1
        seat.res_coin = 1
      end

      seat.save
    end

    @game.next_round()
    @game.action_seat = @game.find_seat_by_number(1)
    @game.save
  end
end
