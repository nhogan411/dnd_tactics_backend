module BattleServices
  class TurnSubmissionService
    def initialize(battle, participant, action_data)
      @battle = battle
      @participant = participant
      @action_data = action_data
      @action_type = action_data[:action_type]
    end

    def valid_submission?
      return false unless @participant.battle == @battle
      return false unless @battle.current_participant == @participant
      return false unless @participant.status == "active"
      return false unless valid_action_type?

      true
    end

    def execute!
      raise "Invalid turn submission" unless valid_submission?

      result = case @action_type
      when "move"
        execute_move
      when "attack"
        execute_attack
      when "ability"
        execute_ability
      when "end_turn"
        execute_end_turn
      else
        raise "Unknown action type: #{@action_type}"
      end

      result
    end

    private

    def valid_action_type?
      %w[move attack ability end_turn].include?(@action_type)
    end

    def execute_move
      target_x = @action_data[:target_x]
      target_y = @action_data[:target_y]

      movement_service = BattleServices::MovementService.new(@participant, target_x, target_y)
      movement_service.execute!
    end

    def execute_attack
      target_id = @action_data[:target_id]
      target = @battle.battle_participants.find(target_id)

      raise "Invalid target" unless valid_attack_target?(target)

      combat_service = BattleServices::CombatService.new(@participant, target)
      result = combat_service.attack(target)

      # Check if battle should end after attack
      check_battle_end

      result
    end

    def execute_ability
      ability_id = @action_data[:ability_id]
      ability = Ability.find(ability_id)

      ability_service = AbilityService.new(@participant, ability)
      ability_service.use!

      {
        success: true,
        ability: ability,
        participant: @participant
      }
    end

    def execute_end_turn
      # Handle end of turn effects
      status_manager = BattleServices::StatusManager.new(@participant)
      status_manager.tick!

      advance_turn

      {
        success: true,
        message: "Turn ended",
        next_participant: @battle.current_participant
      }
    end

    def valid_attack_target?(target)
      return false unless target
      return false if target.team == @participant.team
      return false unless target.status == "active"
      return false unless within_attack_range?(target)

      true
    end

    def within_attack_range?(target)
      # Basic melee range check (adjacent squares)
      distance = (@participant.pos_x - target.pos_x).abs + (@participant.pos_y - target.pos_y).abs
      distance <= 1
    end

    def advance_turn
      turn_service = BattleServices::TurnService.new(@battle)
      turn_service.next_turn!

      # Check for battle end conditions
      check_battle_end
    end

    def check_battle_end
      team1_alive = @battle.team_1_participants.where(status: "active").exists?
      team2_alive = @battle.team_2_participants.where(status: "active").exists?

      if !team1_alive || !team2_alive
        winner = team1_alive ? @battle.player_1 : @battle.player_2
        @battle.update!(
          status: "completed",
          winner: winner
        )

        BattleServices::Logger.log_battle_end(@battle, winner)
      end
    end
  end
end
