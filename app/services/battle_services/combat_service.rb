module BattleServices
  class CombatService
    def attack(target)
      result = {
        base_roll: rand(1..20),
        damage: 0,
        sneak_attack: false,
        critical: false
      }

      # Sneak Attack logic
      if sneak_attack_applicable?(target)
        result[:sneak_attack] = true
        result[:damage] += Utils::DiceRoller.roll("1d6")[:result]
      end

      # Base damage
      result[:damage] += Utils::DiceRoller.roll("1d8")[:result]

      # Rage bonus
      if @attacker.status_effects&.dig("raging")&.positive?
        result[:damage] += 2
      end

      # Apply damage
      target.update!(current_hp: [ target.current_hp - result[:damage], 0 ].max)
      BattleServices::Logger.log_attack(@attacker, target, result)

      if target.current_hp <= 0
        target.update!(status: "knocked_out")
        BattleServices::Logger.log_knockout(target)
      end

      result
    end

    def sneak_attack_applicable?(target)
      @attacker.character.character_class.name == "Rogue" && target.team != @attacker.team && attacker_visible?(target)
    end
  end
end
