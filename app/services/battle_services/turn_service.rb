module BattleServices
  class TurnService
    def initialize(battle)
      @battle = battle
    end

    def current_participant
      @battle.battle_participants.find_by(turn_order: @battle.current_turn_index, status: "active")
    end

    def next_turn!
      current_index = @battle.current_turn_index
      active_participants = @battle.battle_participants.where(status: "active").order(:turn_order)

      Rails.logger.debug "TurnService#next_turn! - current_index: #{current_index}"
      Rails.logger.debug "TurnService#next_turn! - active_participants: #{active_participants.map { |p| "#{p.id}(#{p.turn_order})" }.join(', ')}"

      # Find next active participant
      next_participant = find_next_active_participant(current_index, active_participants)

      Rails.logger.debug "TurnService#next_turn! - next_participant: #{next_participant&.id}(#{next_participant&.turn_order})"

      if next_participant
        Rails.logger.debug "TurnService#next_turn! - updating battle current_turn_index from #{@battle.current_turn_index} to #{next_participant.turn_order}"
        @battle.update!(
          current_turn_index: next_participant.turn_order
          # turn_count: next_participant.turn_order == 0 ? @battle.turn_count + 1 : @battle.turn_count
        )
        Rails.logger.debug "TurnService#next_turn! - battle current_turn_index after update: #{@battle.reload.current_turn_index}"

        Rails.logger.debug "TurnService#next_turn! - updated battle.current_turn_index to: #{@battle.current_turn_index}"

        # Apply start-of-turn effects for the next participant
        apply_start_of_turn_effects(next_participant)

        # Reduce cooldowns for all participants at the start of each turn
        reduce_all_cooldowns

        BattleServices::Logger.log_turn_start(@battle, next_participant)
      else
        # No active participants, battle should end
        end_battle_no_survivors
      end

      next_participant
    end

    def skip_dead_participants!
      current = current_participant

      while current && current.status != "active"
        next_turn!
        current = current_participant

        # Prevent infinite loop
        break if @battle.current_turn_index == @battle.battle_participants.where(status: "active").minimum(:turn_order)
      end
    end

    def reset_turn_order!
      active_participants = @battle.battle_participants.where(status: "active")

      # Re-roll initiative for all active participants
      active_participants.each do |participant|
        initiative_roll = BattleServices::DiceRoller.d20(1, get_dex_modifier(participant.character))
        participant.update!(initiative_roll: initiative_roll[:total])
      end

      # Re-sort by initiative (highest first)
      sorted_participants = active_participants.sort_by { |p| [-p.initiative_roll, -get_dex_modifier(p.character)] }

      sorted_participants.each_with_index do |participant, index|
        participant.update!(turn_order: index)
      end

      @battle.update!(current_turn_index: 0)
      # @battle.update!(current_turn_index: 0, turn_count: @battle.turn_count + 1)

      BattleServices::Logger.log_initiative_reroll(@battle)
    end

    def simulate_attack_turn
      attacker = current_participant
      targets = @battle.battle_participants.where.not(team: attacker.team).where(status: "active")
      return unless targets.any?

      target = targets.sample

      # Use AttackService for proper combat
      attack_service = BattleServices::AttackService.new(attacker, target)
      attack_service.execute!

      next_turn!
    end

    private

    def find_next_active_participant(current_index, active_participants)
      # Get participants with turn_order > current_index
      next_participants = active_participants.where("turn_order > ?", current_index)

      if next_participants.any?
        next_participants.first
      else
        # Wrap to beginning of turn order
        active_participants.first
      end
    end

    def apply_start_of_turn_effects(participant)
      # Handle status effects like regeneration, poison, etc.
      status_manager = BattleServices::StatusManager.new(participant)
      status_manager.handle_start_of_turn_effects
      status_manager.save!
    end

    def reduce_all_cooldowns
      @battle.battle_participants.where(status: "active").each do |participant|
        if participant.cooldowns.present?
          updated_cooldowns = participant.cooldowns.transform_values { |turns| [turns - 1, 0].max }
          updated_cooldowns.reject! { |_, turns| turns == 0 }
          participant.update!(cooldowns: updated_cooldowns)
        end
      end
    end

    def end_battle_no_survivors
      @battle.update!(
        status: "completed",
        winner: nil  # Draw/no survivors
      )

      BattleServices::Logger.log_battle_end(@battle, nil)
    end

    def get_dex_modifier(character)
      dex_score = character.ability_scores.find_by(score_type: "DEX")
      return 0 unless dex_score

      (dex_score.modified_score - 10) / 2
    end
  end
end
