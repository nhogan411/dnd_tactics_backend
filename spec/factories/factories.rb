FactoryBot.define do
  factory :user do
    first_name { "Test" }
    last_name { "User" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end

  factory :race do
    name { "Human" }
    default_visibility_range { 60 }
  end

  factory :subrace do
    name { "Standard Human" }
    race
    ability_modifiers { { "STR" => 1, "DEX" => 1 } }
  end

  factory :character_class do
    name { "Fighter" }
    ability_requirements { {} }
    bonuses { {} }
  end

  factory :subclass do
    name { "Champion" }
    character_class
    bonuses { { "extra_attack" => true } }
  end

  factory :character do
    name { "Test Character" }
    user
    race
    subrace
    character_class
    subclass
    level { 1 }
    movement_speed { 30 }
    max_hp { 10 }
    visibility_range { 60 }
  end

  factory :ability_score do
    character
    score_type { "STR" }
    base_score { 15 }
    modified_score { 15 }
  end

  factory :item do
    name { "Test Item" }
    item_type { "weapon" }
    bonuses { { "STR" => 1 } }
  end

  factory :character_item do
    character
    item
  end

  factory :ability do
    name { "Test Ability" }
    description { "A test ability" }
    class_name { "Fighter" }
    level_required { 1 }
    action_type { "active" }
    cooldown_turns { 1 }
  end

  factory :character_ability do
    character
    ability
    uses_remaining { 1 }
  end

  factory :battle_board do
    name { "Test Board" }
    width { 10 }
    height { 10 }
  end

  factory :board_square do
    battle_board
    x { 1 }
    y { 1 }
    height { 0 }
    brightness { 10 }
    surface_type { "normal" }
  end

  factory :starting_square do
    battle_board
    x { 1 }
    y { 1 }
    team { 1 }
  end

  factory :battle do
    association :player_1, factory: :user
    association :player_2, factory: :user
    battle_board
    status { "pending" }
    current_turn_index { 0 }
  end

  factory :battle_participant do
    battle
    character
    user
    team { 1 }
    current_hp { 10 }
    status { "active" }
    initiative_roll { 15 }
    turn_order { 0 }
    pos_x { 1 }
    pos_y { 1 }
    battle_ability_modifiers { {} }
    status_effects { {} }
    cooldowns { {} }
  end

  factory :battle_log do
    battle
    association :actor, factory: :character
    association :target, factory: :character
    action_type { "attack" }
    message { "Test attack message" }
    result_data { { damage: 5 } }
  end

  factory :battle_participant_selection do
    user
    battle
    character
  end

  factory :character_class_level do
    character
    character_class
    level { 1 }
  end
end
