module BattleServices
  class CombatService
    def initialize(attacker, target = nil)
      @attacker = attacker
      @target = target
    end

    def attack(target)
      @target = target
      attack_service = BattleServices::AttackService.new(@attacker, target)
      attack_service.execute!
    end

    def can_attack?(target)
      attack_service = BattleServices::AttackService.new(@attacker, target)
      attack_service.can_attack?
    end

    def apply_status_effect(effect_name, duration)
      current_effects = @attacker.status_effects || {}
      current_effects[effect_name] = duration
      @attacker.update!(status_effects: current_effects)

      BattleServices::Logger.log_status_effect(@attacker, effect_name, duration)
    end

    def remove_status_effect(effect_name)
      current_effects = @attacker.status_effects || {}
      current_effects.delete(effect_name)
      @attacker.update!(status_effects: current_effects)

      BattleServices::Logger.log_status_effect_removed(@attacker, effect_name)
    end

    def has_status_effect?(effect_name)
      effects = @attacker.status_effects || {}
      effects[effect_name].to_i > 0
    end

    def apply_healing(amount)
      max_hp = @attacker.character.max_hp
      new_hp = [@attacker.current_hp + amount, max_hp].min
      healed_amount = new_hp - @attacker.current_hp

      @attacker.update!(current_hp: new_hp)

      BattleServices::Logger.log_healing(@attacker, healed_amount)

      {
        amount_healed: healed_amount,
        new_hp: new_hp,
        max_hp: max_hp
      }
    end

    def calculate_damage_reduction(damage, damage_type = "physical")
      # Base implementation - can be enhanced with resistances/immunities
      reduction = 0

      # Check for rage damage reduction (barbarian)
      if has_status_effect?("raging") && ["bludgeoning", "piercing", "slashing", "physical"].include?(damage_type)
        reduction += damage / 2  # Rage provides resistance to physical damage
      end

      # Apply armor damage reduction if any
      armor_reduction = get_armor_damage_reduction
      reduction += armor_reduction

      [damage - reduction, 0].max
    end

    private

    def get_armor_damage_reduction
      # Check for equipped armor with damage reduction
      armor = @attacker.character.character_items
        .joins(:item)
        .where(equipped: true, items: { item_type: "armor" })
        .first&.item

      armor ? (armor.bonuses["damage_reduction"] || 0) : 0
    end

    def sneak_attack_applicable?(target)
      # Sneak attack conditions for rogues
      return false unless @attacker.character.character_class.name.downcase.include?("rogue")

      # Check if attacker has advantage or if there's an ally adjacent to target
      has_advantage_conditions?(target) || has_adjacent_ally?(target)
    end

    def has_advantage_conditions?(target)
      # TODO: Implement advantage conditions (hidden, flanking, etc.)
      false
    end

    def has_adjacent_ally?(target)
      allies = @attacker.battle.battle_participants
        .where(team: @attacker.team, status: "active")
        .where.not(id: @attacker.id)

      allies.any? do |ally|
        distance = (ally.pos_x - target.pos_x).abs + (ally.pos_y - target.pos_y).abs
        distance <= 1
      end
    end
  end
end
