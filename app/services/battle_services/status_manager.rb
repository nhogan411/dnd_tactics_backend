module BattleServices
  class StatusManager
    def initialize(participant)
      @participant = participant
      @status_effects = (@participant.status_effects || {}).with_indifferent_access
      @cooldowns = (@participant.cooldowns || {}).with_indifferent_access
    end

    # Call this at the end of a participant’s turn
    def tick!
      tick_status_effects
      tick_cooldowns
      save!
    end

    # Call this at the start of a participant's turn
    def start_of_turn!
      # Apply start-of-turn effects like regeneration, poison, etc.
      handle_start_of_turn_effects
      save!
    end

    def tick_status_effects
      @status_effects.each do |effect, turns|
        @status_effects[effect] = turns - 1
        @status_effects.delete(effect) if @status_effects[effect] <= 0
      end
    end

    def tick_cooldowns
      @cooldowns.each do |ability, turns|
        @cooldowns[ability] = turns - 1
        @cooldowns.delete(ability) if @cooldowns[ability] <= 0
      end
    end

    def save!
      @participant.update!(
        status_effects: @status_effects,
        cooldowns: @cooldowns
      )
    end

    # Called when using an ability with cooldown
    def start_cooldown(ability_name, turns)
      @cooldowns[ability_name] = turns
      save!
    end

    private

    def handle_start_of_turn_effects
      # Handle regeneration
      if @status_effects["regeneration"]
        heal_amount = @status_effects["regeneration"]
        new_hp = [@participant.current_hp + heal_amount, @participant.character.max_hp].min
        @participant.update!(current_hp: new_hp)
      end

      # Handle poison/damage over time
      if @status_effects["poison"]
        damage = @status_effects["poison"]
        new_hp = [@participant.current_hp - damage, 0].max
        @participant.update!(current_hp: new_hp)
      end

      # Add more start-of-turn effects as needed
    end
  end
end
