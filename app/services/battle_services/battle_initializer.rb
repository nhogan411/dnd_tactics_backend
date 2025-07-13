class BattleServices::BattleInitializer
  def initialize(battle, team1_characters, team2_characters)
    @battle = battle
    @team1 = team1_characters
    @team2 = team2_characters
  end

  def run
    participants = []

    assign_team(@team1, 1, participants)
    assign_team(@team2, 2, participants)

    assign_initiative(participants)
    assign_turn_order(participants)

    @battle.update!(status: "active")
    participants
  end

  private

    def assign_team(characters, team_number, participants)
      characters.each do |char|
        participants << BattleParticipant.create!(
          battle: @battle,
          character: char,
          user: char.user,
          team: team_number,
          current_hp: char.max_hp,
          status: "active",
          battle_ability_modifiers: {} # Initialize empty battle modifiers
          # pos_x and pos_y will be set by placement phase
        )
      end
    end

    def assign_initiative(participants)
      participants.each do |bp|
        # Use battle-specific dexterity modifier for initiative
        dex_mod = bp.battle_dexterity_modifier
        bp.initiative_roll = rand(1..20) + dex_mod
        bp.save!
      end
    end

    def assign_turn_order(participants)
      sorted = participants.sort_by { |bp| -bp.initiative_roll }
      sorted.each_with_index do |bp, idx|
        bp.update!(turn_order: idx)
      end
    end
end
