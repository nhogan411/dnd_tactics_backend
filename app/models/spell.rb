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
end
