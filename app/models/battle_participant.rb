class BattleParticipant < ApplicationRecord
  belongs_to :character
  belongs_to :battle
  belongs_to :user
  has_many :ability_scores, through: :character

  # Store battle-specific ability score modifications
  # This should be a JSON column in your database
  # Example: { "STR" => 2, "DEX" => -1 } for temporary effects
  def battle_ability_modifiers
    super || {}
  end

  # Get ability score with battle-specific modifications
  def battle_ability_score(score_type)
    # Use modified_score which includes equipment and racial/class bonuses
    base_score = character.ability_scores.find_by(score_type: score_type)&.modified_score || 10
    battle_modifier = battle_ability_modifiers[score_type] || 0
    base_score + battle_modifier
  end

  # Get ability modifier for battle (includes temporary effects)
  def battle_ability_modifier(score_type)
    score = battle_ability_score(score_type)
    (score - 10) / 2
  end

  # Convenience methods for common ability scores
  def battle_strength
    battle_ability_score("STR")
  end

  def battle_dexterity
    battle_ability_score("DEX")
  end

  def battle_constitution
    battle_ability_score("CON")
  end

  def battle_strength_modifier
    battle_ability_modifier("STR")
  end

  def battle_dexterity_modifier
    battle_ability_modifier("DEX")
  end

  def battle_constitution_modifier
    battle_ability_modifier("CON")
  end

  # Method to apply temporary ability score changes during battle
  def apply_battle_ability_modifier(score_type, modifier)
    current_mods = battle_ability_modifiers
    current_mods[score_type] = (current_mods[score_type] || 0) + modifier
    update!(battle_ability_modifiers: current_mods)
  end

  # Method to remove temporary ability score changes
  def remove_battle_ability_modifier(score_type)
    current_mods = battle_ability_modifiers
    current_mods.delete(score_type)
    update!(battle_ability_modifiers: current_mods)
  end

  def current_hp
    super || character.max_hp
  end

  # Status checks
  def active?
    status == 'active'
  end

  def knocked_out?
    status == 'knocked_out'
  end

  def dead?
    current_hp <= 0
  end

  def alive?
    current_hp > 0
  end

  # Position and movement
  def has_position?
    position.present?
  end

  def at_position?(x, y)
    position == [x, y]
  end

  def move_to(x, y)
    self.position = [x, y]
    save
  end

  def distance_to(target)
    return Float::INFINITY unless has_position? && target.has_position?

    x1, y1 = position
    x2, y2 = target.position
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
  end

  def adjacent_to?(target)
    distance_to(target) <= 1.5 # Accounts for diagonal movement
  end

  # Turn management
  def can_act?
    active? && alive? && character.can_act?
  end

  def has_acted_this_turn?
    # This would need to be tracked in battle logs or a separate field
    false # Placeholder
  end

  # Battle statistics
  def damage_dealt
    battle.participant_damage(character)
  end

  def healing_done
    battle.participant_healing(character)
  end

  def times_attacked
    battle.battle_logs.where(actor: character, action_type: 'attack').count
  end

  def times_hit
    battle.battle_logs.where(target: character, action_type: 'damage').count
  end

  # Audit and summary methods
  def audit
    {
      id: id,
      character: character.name,
      team: team,
      status: status,
      current_hp: current_hp,
      max_hp: character.max_hp,
      position: position,
      battle_ability_modifiers: battle_ability_modifiers,
      damage_dealt: damage_dealt,
      healing_done: healing_done,
      times_attacked: times_attacked,
      times_hit: times_hit,
      can_act: can_act?,
      alive: alive?
    }
  end

  def summary_hash
    {
      id: id,
      character_name: character.name,
      team: team,
      status: status,
      current_hp: current_hp,
      max_hp: character.max_hp,
      position: position
    }
  end

  def attack(target)
    battle = self.battle
    attacker_char = self.character
    target_char = target.character

    # Use battle-specific STR modifier instead of base character modifier
    str_mod = battle_strength_modifier

    # Get weapon bonus (if any STR bonus from item)
    weapon_bonus = attacker_char.items.find { |i| i.item_type == "weapon" }&.bonuses&.dig("STR").to_i

    # Roll 1d8 damage
    damage_roll = rand(1..8)
    total_damage = damage_roll + str_mod + weapon_bonus

    # Apply damage
    target.current_hp = [ target.current_hp - total_damage, 0 ].max
    target.status = "knocked_out" if target.current_hp <= 0
    target.save!

    # Create battle log
    BattleLog.create!(
      battle: battle,
      actor: attacker_char,
      target: target_char,
      action_type: "attack",
      result_data: {
        damage: total_damage,
        roll: damage_roll,
        str_mod: str_mod,
        weapon_bonus: weapon_bonus
      },
      message: "#{attacker_char.name} attacks #{target_char.name} for #{total_damage} damage!"
    )

    total_damage
  end
end
