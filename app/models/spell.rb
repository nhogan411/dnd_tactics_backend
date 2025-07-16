class Spell < ApplicationRecord
  has_many :character_spells, dependent: :destroy
  has_many :characters, through: :character_spells

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :level, inclusion: { in: 0..9 }
  validates :school, presence: true, inclusion: { in: %w[
    abjuration conjuration divination enchantment evocation
    illusion necromancy transmutation
  ] }
  validates :casting_time, presence: true
  validates :range, presence: true
  validates :duration, presence: true

  scope :cantrips, -> { where(level: 0) }
  scope :by_level, ->(level) { where(level: level) }
  scope :by_school, ->(school) { where(school: school) }
  scope :concentration, -> { where(concentration: true) }
  scope :ritual, -> { where(ritual: true) }
  scope :for_class, ->(class_name) { where("class_lists ? :class_name", class_name: class_name) }

  def cantrip?
    level == 0
  end

  def ritual_spell?
    ritual
  end

  def concentration_spell?
    concentration
  end

  def has_verbal_component?
    components['verbal'] == true
  end

  def has_somatic_component?
    components['somatic'] == true
  end

  def has_material_component?
    components['material'] == true
  end

  def spell_level_text
    case level
    when 0 then "Cantrip"
    when 1 then "1st-level"
    when 2 then "2nd-level"
    when 3 then "3rd-level"
    else "#{level}th-level"
    end
  end

  def component_text
    comp_array = []
    comp_array << "V" if has_verbal_component?
    comp_array << "S" if has_somatic_component?
    comp_array << "M" if has_material_component?
    comp_array.join(", ")
  end

  def full_component_text
    text = component_text
    text += " (#{material_components})" if has_material_component? && material_components.present?
    text
  end

  def available_to_class?(class_name)
    class_lists.include?(class_name.downcase)
  end

  def deals_damage?
    damage.present? && damage.any?
  end

  def healing_spell?
    effects.key?('healing')
  end

  def requires_save?
    saving_throw.present?
  end

  def requires_attack_roll?
    attack_type.present?
  end

  def upcast_damage(slot_level)
    return damage unless at_higher_levels.present? && slot_level > level

    # This would need to be implemented based on specific spell mechanics
    # For now, return base damage
    damage
  end

  # Spell mechanics
  def instantaneous?
    duration.downcase == 'instantaneous'
  end

  def has_duration?
    !instantaneous?
  end

  def self_target?
    range.downcase == 'self'
  end

  def touch_spell?
    range.downcase == 'touch'
  end

  def has_range?
    !self_target? && !touch_spell?
  end

  def range_in_feet
    return 0 if self_target? || touch_spell?

    # Extract number from range string (e.g., "120 feet" -> 120)
    range.scan(/\d+/).first&.to_i || 0
  end

  def aoe_spell?
    range.include?('radius') || range.include?('cone') || range.include?('line') || range.include?('cube')
  end

  def target_multiple?
    aoe_spell? || description.include?('each creature') || description.include?('all creatures')
  end

  def can_be_upcast?
    at_higher_levels.present?
  end

  def minimum_caster_level
    return 1 if cantrip?

    # Calculate minimum character level needed to cast this spell
    case level
    when 1 then 1
    when 2 then 3
    when 3 then 5
    when 4 then 7
    when 5 then 9
    when 6 then 11
    when 7 then 13
    when 8 then 15
    when 9 then 17
    end
  end

  def damage_dice
    return nil unless deals_damage?
    damage['dice']
  end

  def damage_type
    return nil unless deals_damage?
    damage['type']
  end

  def average_damage
    return 0 unless deals_damage?

    dice = damage_dice
    return 0 unless dice

    # Parse dice string like "3d6" to calculate average
    if dice.match(/(\d+)d(\d+)/)
      count = $1.to_i
      sides = $2.to_i
      average_per_die = (sides + 1) / 2.0
      (count * average_per_die).round
    else
      0
    end
  end

  def healing_dice
    return nil unless healing_spell?
    effects.dig('healing', 'dice')
  end

  def average_healing
    return 0 unless healing_spell?

    dice = healing_dice
    return 0 unless dice

    # Parse dice string like "1d8" to calculate average
    if dice.match(/(\d+)d(\d+)/)
      count = $1.to_i
      sides = $2.to_i
      average_per_die = (sides + 1) / 2.0
      (count * average_per_die).round
    else
      0
    end
  end

  def applies_condition?
    effects.key?('condition')
  end

  def condition_applied
    return nil unless applies_condition?
    effects['condition']
  end

  # Spell list helpers
  def wizard_spell?
    available_to_class?('wizard')
  end

  def cleric_spell?
    available_to_class?('cleric')
  end

  def druid_spell?
    available_to_class?('druid')
  end

  def sorcerer_spell?
    available_to_class?('sorcerer')
  end

  def warlock_spell?
    available_to_class?('warlock')
  end

  def bard_spell?
    available_to_class?('bard')
  end

  def paladin_spell?
    available_to_class?('paladin')
  end

  def ranger_spell?
    available_to_class?('ranger')
  end

  def available_classes
    class_lists.map(&:humanize)
  end

  def school_description
    case school
    when 'abjuration' then 'Abjuration spells are protective in nature'
    when 'conjuration' then 'Conjuration spells create objects or bring creatures'
    when 'divination' then 'Divination spells reveal information'
    when 'enchantment' then 'Enchantment spells affect minds'
    when 'evocation' then 'Evocation spells manipulate energy'
    when 'illusion' then 'Illusion spells deceive the senses'
    when 'necromancy' then 'Necromancy spells manipulate life and death'
    when 'transmutation' then 'Transmutation spells change properties'
    else 'Unknown school'
    end
  end

  # Audit and summary methods
  def audit
    {
      name: name,
      level: level,
      school: school,
      casting_time: casting_time,
      range: range,
      duration: duration,
      concentration: concentration,
      ritual: ritual,
      components: components,
      material_components: material_components,
      damage: damage,
      effects: effects,
      saving_throw: saving_throw,
      attack_type: attack_type,
      class_lists: class_lists,
      at_higher_levels: at_higher_levels,
      average_damage: average_damage,
      average_healing: average_healing
    }
  end

  def summary_hash
    {
      id: id,
      name: name,
      level: level,
      school: school,
      casting_time: casting_time,
      range: range,
      duration: duration,
      concentration: concentration,
      ritual: ritual,
      components: component_text,
      classes: available_classes,
      damage: deals_damage? ? "#{damage_dice} #{damage_type}" : nil,
      healing: healing_spell? ? "#{healing_dice}" : nil
    }
  end
end
