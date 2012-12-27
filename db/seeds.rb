# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if BuildingCard.count == 0
  # Heartland starting buildings
  BuildingCard.create(name: "Clay Mound", variant: GameVariant::ALL, key: "H01", is_base: true, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 0, dwelling_value: 3)

  BuildingCard.create(name: "Farmyard", variant: GameVariant::ALL, key: "H02", is_base: true, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::PLAINS, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 0, dwelling_value: 2)

  BuildingCard.create(name: "Cloister Office", variant: GameVariant::ALL, key: "H03", is_base: true, is_cloister: true, 
    age: Age::START, available_location_types: LocationType::PLAINS, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 0, dwelling_value: 2)


  # Forest & Moor cards
  BuildingCard.create(name: "Forest", variant: GameVariant::ALL, key: "R01", is_base: true, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 0, dwelling_value: 0)

  BuildingCard.create(name: "Moor", variant: GameVariant::ALL, key: "R02", is_base: true, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 0, dwelling_value: 0)


  # Settlements
  BuildingCard.create(name: "Shanty Town", variant: GameVariant::ALL, key: "S01", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 1, cost_food: 1, 
    economic_value: 0, dwelling_value: -3)

  BuildingCard.create(name: "Farming Village", variant: GameVariant::ALL, key: "S02", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 3, cost_food: 3, 
    economic_value: 1, dwelling_value: 1)

  BuildingCard.create(name: "Market Town", variant: GameVariant::ALL, key: "S03", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 7, 
    economic_value: 2, dwelling_value: 2)

  BuildingCard.create(name: "Fishing Village", variant: GameVariant::ALL, key: "S04", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 3, cost_food: 8, 
    economic_value: 4, dwelling_value: 6)

  BuildingCard.create(name: "Artist's Colony", variant: GameVariant::ALL, key: "S05", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 1, cost_food: 5, 
    economic_value: -1, dwelling_value: 5)

  BuildingCard.create(name: "Hamlet", variant: GameVariant::ALL, key: "S06", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 6, cost_food: 5, 
    economic_value: 3, dwelling_value: 4)

  BuildingCard.create(name: "Village", variant: GameVariant::ALL, key: "S07", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 9, cost_food: 15, 
    economic_value: 8, dwelling_value: 6)

  BuildingCard.create(name: "Hilltop Village", variant: GameVariant::ALL, key: "S08", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 3, cost_food: 30, 
    economic_value: 10, dwelling_value: 8)


  # Other (France & Ireland) buildings
  BuildingCard.create(name: "Priory", variant: GameVariant::ALL, key: "G01", is_base: false, is_cloister: true, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 1, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 3)

  BuildingCard.create(name: "Cloister Courtyard", variant: GameVariant::ALL, key: "G02", is_base: false, is_cloister: true, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 4)

  BuildingCard.create(name: "Grain Storage", variant: GameVariant::FRANCE, key: "F03", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 4)

  BuildingCard.create(name: "Granary", variant: GameVariant::IRELAND, key: "I03", is_base: false, is_cloister: true, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 3)

  BuildingCard.create(name: "Windmill", variant: GameVariant::FRANCE, key: "F04", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 10, dwelling_value: 6)

  BuildingCard.create(name: "Malthouse", variant: GameVariant::IRELAND, key: "I04", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 4)

  BuildingCard.create(name: "Bakery", variant: GameVariant::FRANCE, key: "F05", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 5)

  BuildingCard.create(name: "Brewery", variant: GameVariant::IRELAND, key: "I05", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 2, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 9, dwelling_value: 7)

  BuildingCard.create(name: "Fuel Merchant", variant: GameVariant::ALL, key: "G06", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 2)

  BuildingCard.create(name: "Peat Coal Kiln", variant: GameVariant::ALL, key: "G07", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: -2)

  BuildingCard.create(name: "Market", variant: GameVariant::FRANCE, key: "F08", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 2, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 8)

  BuildingCard.create(name: "False Lighthouse", variant: GameVariant::IRELAND, key: "I08", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 1, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 5)

  BuildingCard.create(name: "Cloister Garden", variant: GameVariant::FRANCE, key: "F09", is_base: false, is_cloister: true, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 3, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 0)

  BuildingCard.create(name: "Spinning Mill", variant: GameVariant::IRELAND, key: "I09", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 3)

  BuildingCard.create(name: "Carpentry", variant: GameVariant::FRANCE, key: "F10", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 1, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: 0)

  BuildingCard.create(name: "Cottage", variant: GameVariant::IRELAND, key: "I10", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 1, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 0)

  BuildingCard.create(name: "Harbor Promenade", variant: GameVariant::FRANCE, key: "F11", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 1, dwelling_value: 7)

  BuildingCard.create(name: "Houseboat", variant: GameVariant::IRELAND, key: "I11", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::WATER, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 6)

  BuildingCard.create(name: "Stone Merchant", variant: GameVariant::ALL, key: "G12", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 1)

  BuildingCard.create(name: "Builders' Market", variant: GameVariant::ALL, key: "G13", is_base: false, is_cloister: false, 
    age: Age::START, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 1)

  BuildingCard.create(name: "Grapevine", variant: GameVariant::FRANCE, key: "F14", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 6)

  BuildingCard.create(name: "Sacred Site", variant: GameVariant::IRELAND, key: "I14", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 6)

  BuildingCard.create(name: "Financed Estate", variant: GameVariant::FRANCE, key: "F15", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 6)

  BuildingCard.create(name: "Druid's House", variant: GameVariant::IRELAND, key: "I15", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 6)

  BuildingCard.create(name: "Cloister Chapter House", variant: GameVariant::ALL, key: "G16", is_base: false, is_cloister: true, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 3, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 5)

  BuildingCard.create(name: "Cloister Library", variant: GameVariant::FRANCE, key: "F17", is_base: false, is_cloister: true, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 2, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: 7)

  BuildingCard.create(name: "Scriptorium", variant: GameVariant::IRELAND, key: "I17", is_base: false, is_cloister: true, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 5)

  BuildingCard.create(name: "Cloister Workshop", variant: GameVariant::ALL, key: "G18", is_base: false, is_cloister: true, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: 2)

  BuildingCard.create(name: "Slaughterhouse", variant: GameVariant::ALL, key: "G19", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 8, dwelling_value: -3)

  BuildingCard.create(name: "Inn", variant: GameVariant::FRANCE, key: "F20", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 0, cost_stone: 0, cost_straw: 2, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 6)

  BuildingCard.create(name: "Alehouse", variant: GameVariant::IRELAND, key: "I20", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 6)

  BuildingCard.create(name: "Winery", variant: GameVariant::FRANCE, key: "F21", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 2, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 5)

  BuildingCard.create(name: "Whiskey Distillery", variant: GameVariant::IRELAND, key: "I21", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 2, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 5)

  BuildingCard.create(name: "Quarry", variant: GameVariant::ALL, key: "G22", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::MOUNTAIN, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 5, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: -4)

  BuildingCard.create(name: "Bathhouse", variant: GameVariant::FRANCE, key: "F23", is_base: false, is_cloister: true, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 1, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 6)

  BuildingCard.create(name: "Locutory", variant: GameVariant::IRELAND, key: "I23", is_base: false, is_cloister: true, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: 1)

  BuildingCard.create(name: "Cloister Church", variant: GameVariant::FRANCE, key: "F24", is_base: false, is_cloister: true, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 5, cost_stone: 3, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 12, dwelling_value: 9)

  BuildingCard.create(name: "Chapel", variant: GameVariant::IRELAND, key: "I24", is_base: false, is_cloister: true, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 3, cost_stone: 3, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 10, dwelling_value: 8)

  BuildingCard.create(name: "Chamber of Wonders", variant: GameVariant::FRANCE, key: "F25", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 1, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 0, dwelling_value: 6)

  BuildingCard.create(name: "Portico", variant: GameVariant::IRELAND, key: "I25", is_base: false, is_cloister: true, 
    age: Age::B, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 6)

  BuildingCard.create(name: "Shipyard", variant: GameVariant::ALL, key: "G26", is_base: false, is_cloister: false, 
    age: Age::B, available_location_types: LocationType::COAST, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 4, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 15, dwelling_value: -2)

  BuildingCard.create(name: "Palace", variant: GameVariant::FRANCE, key: "F27", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 25, cost_fuel: 0, cost_food: 0, 
    economic_value: 25, dwelling_value: 8)

  BuildingCard.create(name: "Grand Manor", variant: GameVariant::IRELAND, key: "I27", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 20, cost_fuel: 0, cost_food: 0, 
    economic_value: 18, dwelling_value: 7)

  BuildingCard.create(name: "Castle", variant: GameVariant::ALL, key: "G28", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::HILLSIDE | LocationType::MOUNTAIN, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 6, cost_clay: 0, cost_stone: 5, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 15, dwelling_value: 7)

  BuildingCard.create(name: "Quarry", variant: GameVariant::FRANCE, key: "F29", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::MOUNTAIN, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 5, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: -4)

  BuildingCard.create(name: "Forest Hut", variant: GameVariant::IRELAND, key: "I29", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 1, dwelling_value: 5)

  BuildingCard.create(name: "Town Estate", variant: GameVariant::FRANCE, key: "F30", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 2, cost_straw: 2, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 5)

  BuildingCard.create(name: "Refectory", variant: GameVariant::IRELAND, key: "I30", is_base: false, is_cloister: true, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 5)

  BuildingCard.create(name: "Grapevine", variant: GameVariant::FRANCE, key: "F31", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 6)

  BuildingCard.create(name: "Coal Harbor", variant: GameVariant::IRELAND, key: "I31", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 2, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 12, dwelling_value: 0)

  BuildingCard.create(name: "Calefactory", variant: GameVariant::FRANCE, key: "F32", is_base: false, is_cloister: true, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 5)

  BuildingCard.create(name: "Filial Church", variant: GameVariant::IRELAND, key: "I32", is_base: false, is_cloister: true, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 4, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 7)

  BuildingCard.create(name: "Shipping Company", variant: GameVariant::FRANCE, key: "F33", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 3, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 8, dwelling_value: 4)

  BuildingCard.create(name: "Cooperage", variant: GameVariant::IRELAND, key: "I33", is_base: false, is_cloister: false, 
    age: Age::C, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 3, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 3)

  BuildingCard.create(name: "Sacristy", variant: GameVariant::ALL, key: "G34", is_base: false, is_cloister: true, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 3, cost_straw: 2, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 10, dwelling_value: 7)

  BuildingCard.create(name: "Forger's Workshop", variant: GameVariant::FRANCE, key: "F35", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 4, dwelling_value: 2)

  BuildingCard.create(name: "Round Tower", variant: GameVariant::IRELAND, key: "I35", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 4, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 6, dwelling_value: 9)

  BuildingCard.create(name: "Pilgrimage Site", variant: GameVariant::FRANCE, key: "F36", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 6, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 6)

  BuildingCard.create(name: "Camera", variant: GameVariant::IRELAND, key: "I36", is_base: false, is_cloister: true, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 2, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 3)

  BuildingCard.create(name: "Dormitory", variant: GameVariant::FRANCE, key: "F37", is_base: false, is_cloister: true, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 3, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 4)

  BuildingCard.create(name: "Bulwark", variant: GameVariant::IRELAND, key: "I37", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 4, cost_stone: 0, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 8, dwelling_value: 6)

  BuildingCard.create(name: "Printing Office", variant: GameVariant::FRANCE, key: "F38", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 1, cost_clay: 0, cost_stone: 2, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 5)

  BuildingCard.create(name: "Festival Ground", variant: GameVariant::IRELAND, key: "I38", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 10, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 7)

  BuildingCard.create(name: "Estate", variant: GameVariant::ALL, key: "G39", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::FOUR, 
    cost_wood: 2, cost_clay: 0, cost_stone: 2, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 5, dwelling_value: 6)

  BuildingCard.create(name: "Hospice", variant: GameVariant::FRANCE, key: "F40", is_base: false, is_cloister: true, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 0, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: 5)

  BuildingCard.create(name: "Guesthouse", variant: GameVariant::IRELAND, key: "F40", is_base: false, is_cloister: false, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 3, cost_clay: 0, cost_stone: 0, cost_straw: 1, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 7, dwelling_value: 5)

  BuildingCard.create(name: "House of the Brotherhood", variant: GameVariant::ALL, key: "G41", is_base: false, is_cloister: true, 
    age: Age::D, available_location_types: LocationType::COAST | LocationType::PLAINS | LocationType::HILLSIDE, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 1, cost_stone: 1, cost_straw: 0, cost_coin: 0, cost_fuel: 0, cost_food: 0, 
    economic_value: 3, dwelling_value: 3)

  # Expansion cards
  BuildingCard.create(name: "Loamy Landscape", variant: GameVariant::FRANCE, key: "FL1", is_base: false, is_cloister: false, 
    age: Age::A, available_location_types: LocationType::CLAYMOUND, 
    number_players: NumberOfPlayers::ONE | NumberOfPlayers::TWO | NumberOfPlayers::THREE | NumberOfPlayers::FOUR, 
    cost_wood: 0, cost_clay: 0, cost_stone: 0, cost_straw: 0, cost_coin: 3, cost_fuel: 0, cost_food: 0, 
    economic_value: 2, dwelling_value: 0)
end