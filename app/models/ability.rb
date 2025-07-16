class Ability < ApplicationRecord
  has_many :character_abilities, dependent: :destroy
  has_many :characters, through: :character_abilities

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :ability_type, presence: true, inclusion: {
    in: %w[class_feature racial_trait feat spell cantrip action bonus_action reaction legendary_action]
  }
  validates :action_type, presence: true, inclusion: {
    in: %w[action bonus_action reaction free_action passive legendary_action]
  }
  validates :level_required, presence: true, numericality: { greater_than: 0 }
  validates :cooldown_turns, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :by_type, ->(type) { where(ability_type: type) }
  scope :by_source, ->(source) { where(source: source) }
  scope :by_level, ->(level) { where(level_required: level) }
  scope :by_action_type, ->(action_type) { where(action_type: action_type) }
  scope :class_features, -> { where(ability_type: 'class_feature') }
  scope :racial_traits, -> { where(ability_type: 'racial_trait') }
  scope :spells, -> { where(ability_type: ['spell', 'cantrip']) }
  scope :combat_abilities, -> { where(action_type: ['action', 'bonus_action', 'reaction']) }
  scope :passive_abilities, -> { where(action_type: 'passive') }

  # Methods
  def is_spell?
    ability_type.in?(['spell', 'cantrip'])
  end

  def is_cantrip?
    ability_type == 'cantrip'
  end

  def is_class_feature?
    ability_type == 'class_feature'
  end

  def is_racial_trait?
    ability_type == 'racial_trait'
  end

  def is_combat_ability?
    action_type.in?(['action', 'bonus_action', 'reaction'])
  end

  def is_passive?
    action_type == 'passive'
  end

  def has_damage?
    damage_dice.present?
  end

  def has_saving_throw?
    saving_throw.present?
  end

  def has_components?
    components.present? && components.any?
  end

  def verbal_component?
    components.dig('verbal') == true
  end

  def somatic_component?
    components.dig('somatic') == true
  end

  def material_component?
    components.dig('material').present?
  end

  def material_components
    components.dig('material') || ""
  end

  def has_prerequisites?
    prerequisites.present? && prerequisites.any?
  end

  def meets_prerequisites?(character)
    return true unless has_prerequisites?

    prerequisites.all? do |req_type, req_value|
      case req_type
      when 'level'
        character.level >= req_value
      when 'class'
        character.character_class.name == req_value
      when 'ability_score'
        req_value.all? { |ability, min_score| character.ability_score(ability) >= min_score }
      when 'proficiency'
        # Check if character has required proficiency
        true # Implement based on character proficiency system
      else
        true
      end
    end
  end

  def limited_uses?
    uses_per_rest.present? && max_uses.present?
  end

  def unlimited_uses?
    uses_per_rest == 'unlimited' || (!limited_uses? && cooldown_turns == 0)
  end

  def short_rest_recharge?
    uses_per_rest == 'short_rest'
  end

  def long_rest_recharge?
    uses_per_rest == 'long_rest'
  end

  def has_recharge?
    recharge.present?
  end

  def scales_with_level?
    scaling.present? && scaling.any?
  end

  def scaling_at_level(level)
    return {} unless scales_with_level?

    applicable_scaling = scaling.select { |req_level, _| level >= req_level.to_i }
    return {} if applicable_scaling.empty?

    highest_level = applicable_scaling.keys.map(&:to_i).max
    scaling[highest_level.to_s] || {}
  end

  def display_duration
    return "Instantaneous" if duration.blank?
    duration
  end

  def display_range
    return "Self" if range.blank?
    range
  end

  def display_damage
    return nil unless has_damage?
    base = damage_dice
    damage_type.present? ? "#{base} #{damage_type}" : base
  end

  def display_components
    return "None" unless has_components?

    comp_parts = []
    comp_parts << "V" if verbal_component?
    comp_parts << "S" if somatic_component?
    comp_parts << "M (#{material_components})" if material_component?

    comp_parts.join(", ")
  end

  def display_uses
    return "Unlimited" if unlimited_uses?
    return "#{max_uses}/#{uses_per_rest.humanize}" if limited_uses?
    return "Recharge #{recharge}" if has_recharge?
    return "#{cooldown_turns} turn cooldown" if cooldown_turns > 0
    "At will"
  end

  def display_action_type
    case action_type
    when 'bonus_action' then 'Bonus Action'
    when 'free_action' then 'Free Action'
    when 'legendary_action' then 'Legendary Action'
    else action_type.humanize
    end
  end

  # Audit ability for a given character and level
  def audit_for(character, level)
    {
      name: name,
      type: ability_type,
      action_type: action_type,
      level_required: level_required,
      available: meets_prerequisites?(character) && level >= level_required,
      scaling: scales_with_level? ? scaling_at_level(level) : nil,
      usage: display_uses,
      damage: display_damage,
      range: display_range,
      duration: display_duration,
      components: display_components,
      prerequisites: prerequisites,
      limited_uses: limited_uses?,
      unlimited_uses: unlimited_uses?,
      recharge: recharge,
      has_recharge: has_recharge?,
      has_damage: has_damage?,
      has_saving_throw: has_saving_throw?,
      has_components: has_components?
    }
  end

  # Summary hash for API/UI
  def summary_hash
    {
      id: id,
      name: name,
      type: ability_type,
      action_type: action_type,
      level_required: level_required,
      description: description,
      range: display_range,
      duration: display_duration,
      damage: display_damage,
      components: display_components,
      usage: display_uses
    }
  end
end
