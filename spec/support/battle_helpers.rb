module BattleTestHelpers
  def setup_basic_battle
    user1 = create(:user, first_name: "Alice")
    user2 = create(:user, first_name: "Bob")

    race = create(:race)
    subrace = create(:subrace, race: race)
    character_class = create(:character_class)
    subclass = create(:subclass, character_class: character_class)

    char1 = create(:character,
      user: user1,
      race: race,
      subrace: subrace,
      character_class: character_class,
      subclass: subclass,
      name: "Hero1"
    )

    char2 = create(:character,
      user: user2,
      race: race,
      subrace: subrace,
      character_class: character_class,
      subclass: subclass,
      name: "Hero2"
    )

    # Create ability scores for characters
    %w[STR DEX CON INT WIS CHA].each do |score_type|
      create(:ability_score, character: char1, score_type: score_type, base_score: 15, modified_score: 15)
      create(:ability_score, character: char2, score_type: score_type, base_score: 15, modified_score: 15)
    end

    battle_board = create(:battle_board)
    battle = create(:battle, player_1: user1, player_2: user2, battle_board: battle_board)

    participant1 = create(:battle_participant,
      battle: battle,
      character: char1,
      user: user1,
      team: 1,
      turn_order: 0,
      pos_x: 2,
      pos_y: 2
    )

    participant2 = create(:battle_participant,
      battle: battle,
      character: char2,
      user: user2,
      team: 2,
      turn_order: 1,
      pos_x: 8,
      pos_y: 8
    )

    {
      battle: battle,
      user1: user1,
      user2: user2,
      char1: char1,
      char2: char2,
      participant1: participant1,
      participant2: participant2
    }
  end
end

RSpec.configure do |config|
  config.include BattleTestHelpers
end
