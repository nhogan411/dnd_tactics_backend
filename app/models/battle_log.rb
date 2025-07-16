class BattleLog < ApplicationRecord
  belongs_to :battle
  belongs_to :actor, class_name: "Character", optional: true
  belongs_to :target, class_name: "Character", optional: true

  validates :action_type, presence: true
  validates :message, presence: true

  # Action type checks
  def attack?
    action_type == 'attack'
  end

  def damage?
    action_type == 'damage'
  end

  def heal?
    action_type == 'heal'
  end

  def movement?
    action_type == 'movement'
  end

  def spell?
    action_type == 'spell'
  end

  def ability?
    action_type == 'ability'
  end

  def system?
    action_type == 'system'
  end

  # Data extraction helpers
  def damage_amount
    result_data.dig('damage') || 0
  end

  def healing_amount
    result_data.dig('healing') || 0
  end

  def dice_roll
    result_data.dig('roll')
  end

  def modifier_applied
    result_data.dig('modifier') || 0
  end

  def critical_hit?
    result_data.dig('critical') == true
  end

  def missed?
    result_data.dig('hit') == false
  end

  def hit?
    result_data.dig('hit') == true
  end

  def spell_used
    result_data.dig('spell')
  end

  def ability_used
    result_data.dig('ability')
  end

  def position_from
    result_data.dig('from')
  end

  def position_to
    result_data.dig('to')
  end

  def distance_moved
    return 0 unless position_from && position_to

    x1, y1 = position_from
    x2, y2 = position_to
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2).round(1)
  end

  # Log categorization
  def combat_action?
    %w[attack damage heal spell ability].include?(action_type)
  end

  def non_combat_action?
    !combat_action?
  end

  def has_target?
    target_id.present?
  end

  def has_actor?
    actor_id.present?
  end

  def system_message?
    system? || (!has_actor? && !has_target?)
  end

  def player_action?
    has_actor? && !system_message?
  end

  # Display helpers
  def display_timestamp
    created_at.strftime("%H:%M:%S")
  end

  def short_message
    message.truncate(50)
  end

  def detailed_message
    base = message

    if damage? && damage_amount > 0
      base += " (#{damage_amount} damage)"
    elsif heal? && healing_amount > 0
      base += " (#{healing_amount} healing)"
    elsif dice_roll
      base += " (rolled #{dice_roll})"
    end

    base
  end

  # Audit and summary methods
  def audit
    {
      id: id,
      battle_id: battle_id,
      action_type: action_type,
      actor: actor&.name,
      target: target&.name,
      message: message,
      result_data: result_data,
      timestamp: created_at,
      damage: damage_amount,
      healing: healing_amount,
      critical: critical_hit?,
      hit: hit?,
      spell: spell_used,
      ability: ability_used
    }
  end

  def summary_hash
    {
      id: id,
      timestamp: display_timestamp,
      action_type: action_type,
      actor: actor&.name,
      target: target&.name,
      message: short_message,
      damage: damage_amount,
      healing: healing_amount
    }
  end
end
