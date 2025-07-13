module BattleServices
  class TurnService
    def initialize(battle)
      @battle = battle
      @participants = battle.battle_participants.order(:turn_order)
      @current_index = (battle.current_turn_index || 0) % @participants.count
    end

    def current_participant
      @participants[@current_index]
    end

    def next_turn!
      @battle.increment!(:current_turn_index)
      @current_index = (@battle.current_turn_index || 0) % @participants.count
    end

    def simulate_attack_turn
      attacker = current_participant
      targets = @participants.select { |p| p.team != attacker.team && p.status == "active" }
      return unless targets.any?

      target = targets.sample
      attacker.attack(target)  # Use the attack method from BattleParticipant

      next_turn!
    end
  end
end
