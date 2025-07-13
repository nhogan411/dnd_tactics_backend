FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end

  factory :race do
    name { "Human" }
    default_visibility_range { 60 }
  end

  factory :subrace do
    name { "Variant Human" }
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
    modified_score { 16 }
  end

  factory :battle_board do
    name { "Test Arena" }
    width { 20 }
    height { 20 }
  end

  factory :battle do
    association :player_1, factory: :user
    association :player_2, factory: :user
    battle_board
    status { "pending" }
  end

  factory :battle_participant do
    battle
    character
    user { character.user }
    team { 1 }
    current_hp { character.max_hp }
    status { "active" }
    pos_x { 5 }
    pos_y { 5 }
    initiative_roll { 15 }
    turn_order { 0 }
  end

  factory :ability do
    name { "Test Ability" }
    description { "A test ability" }
    class_name { "Fighter" }
    level_required { 1 }
    action_type { "active" }
    cooldown_turns { 3 }
  end

  factory :character_ability do
    character
    ability
    uses_remaining { 1 }
  end

  factory :item do
    name { "Test Sword" }
    item_type { "weapon" }
    bonuses { { "STR" => 2 } }
  end

  factory :character_item do
    character
    item
  end
end
