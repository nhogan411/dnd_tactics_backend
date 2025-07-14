module BattleServices
  class AttackService
    def initialize(attacker, target, weapon = nil)
      @attacker = attacker
      @target = target
      @weapon = weapon || get_equipped_weapon(attacker)
      @character = attacker.character
    end

    def execute!
      # Validate attack
      raise "Invalid attack target" unless valid_target?
      raise "Target out of range" unless in_range?

      # Roll attack
      attack_roll = roll_attack
      target_ac = calculate_target_ac

      if attack_roll[:total] >= target_ac
        # Hit! Roll damage
        damage_result = roll_damage
        apply_damage(damage_result)

        result = {
          success: true,
          hit: true,
          attack_roll: attack_roll,
          target_ac: target_ac,
          damage: damage_result,
          target_hp: @target.current_hp
        }
      else
        # Miss
        result = {
          success: true,
          hit: false,
          attack_roll: attack_roll,
          target_ac: target_ac,
          damage: { total: 0 },
          target_hp: @target.current_hp
        }
      end

      # Log the attack
      BattleServices::Logger.log_attack(@attacker, @target, result)

      # Check if target is defeated
      if @target.current_hp <= 0
        @target.update!(status: "defeated")
        BattleServices::Logger.log_defeat(@target)
      end

      result
    end

    def can_attack?
      valid_target? && in_range?
    end

    private

    def valid_target?
      return false unless @target
      return false if @target.team == @attacker.team
      return false unless @target.status == "active"
      true
    end

    def in_range?
      distance = calculate_distance(@attacker, @target)
      weapon_range = @weapon ? (@weapon.bonuses["range"] || 1) : 1

      distance <= weapon_range
    end

    def calculate_distance(participant1, participant2)
      # Manhattan distance for grid-based movement
      (participant1.pos_x - participant2.pos_x).abs +
      (participant1.pos_y - participant2.pos_y).abs
    end

    def roll_attack
      # Get ability modifier (STR for melee, DEX for ranged by default)
      ability_modifier = get_attack_ability_modifier
      proficiency_bonus = get_proficiency_bonus
      weapon_bonus = @weapon ? (@weapon.bonuses["attack"] || 0) : 0

      total_modifier = ability_modifier + proficiency_bonus + weapon_bonus

      # Check for advantage/disadvantage
      if has_advantage?
        BattleServices::DiceRoller.d20_advantage(total_modifier)
      elsif has_disadvantage?
        BattleServices::DiceRoller.d20_disadvantage(total_modifier)
      else
        BattleServices::DiceRoller.d20(1, total_modifier)
      end
    end

    def roll_damage
      if @weapon && @weapon.bonuses["damage_dice"]
        # Parse weapon damage (e.g., "1d8+3")
        base_damage = BattleServices::DiceRoller.parse_and_roll(@weapon.bonuses["damage_dice"])
      else
        # Default unarmed damage
        base_damage = BattleServices::DiceRoller.roll(4, 1, 0)  # 1d4 unarmed
      end

      # Add ability modifier to damage
      ability_modifier = get_damage_ability_modifier
      weapon_bonus = @weapon ? (@weapon.bonuses["damage"] || 0) : 0

      total_damage = base_damage[:total] + ability_modifier + weapon_bonus

      {
        total: [total_damage, 1].max,  # Minimum 1 damage
        base_roll: base_damage,
        ability_modifier: ability_modifier,
        weapon_bonus: weapon_bonus
      }
    end

    def apply_damage(damage_result)
      new_hp = [@target.current_hp - damage_result[:total], 0].max
      @target.update!(current_hp: new_hp)
    end

    def calculate_target_ac
      # Base AC is 10
      base_ac = 10

      # Add DEX modifier
      dex_modifier = get_ability_modifier(@target.character, "DEX")

      # Add armor AC if equipped
      armor_bonus = get_armor_bonus(@target)

      base_ac + dex_modifier + armor_bonus
    end

    def get_equipped_weapon(participant)
      # Find equipped weapon
      participant.character.character_items
        .joins(:item)
        .where(equipped: true, items: { item_type: "weapon" })
        .first&.item
    end

    def get_armor_bonus(participant)
      # Find equipped armor
      armor = participant.character.character_items
        .joins(:item)
        .where(equipped: true, items: { item_type: "armor" })
        .first&.item

      armor ? (armor.bonuses["ac"] || 0) : 0
    end

    def get_attack_ability_modifier
      # For now, use STR for melee weapons, DEX for ranged
      ability = weapon_is_ranged? ? "DEX" : "STR"
      get_ability_modifier(@character, ability)
    end

    def get_damage_ability_modifier
      # Same as attack ability for now
      get_attack_ability_modifier
    end

    def weapon_is_ranged?
      return false unless @weapon
      @weapon.bonuses["weapon_type"] == "ranged" ||
      @weapon.bonuses["range"].to_i > 1
    end

    def get_ability_modifier(character, ability_type)
      ability_score = character.ability_scores.find_by(score_type: ability_type)
      return 0 unless ability_score

      (ability_score.modified_score - 10) / 2
    end

    def get_proficiency_bonus
      # Proficiency bonus based on character level
      level = @character.level
      case level
      when 1..4 then 2
      when 5..8 then 3
      when 9..12 then 4
      when 13..16 then 5
      when 17..20 then 6
      else 2
      end
    end

    def has_advantage?
      # Check for advantage conditions
      # TODO: Implement advantage logic (flanking, hidden, etc.)
      false
    end

    def has_disadvantage?
      # Check for disadvantage conditions
      # TODO: Implement disadvantage logic (prone, blinded, etc.)
      false
    end
  end
end
