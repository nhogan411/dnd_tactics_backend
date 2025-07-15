class CharacterClass < ApplicationRecord
  has_many :subclasses, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :character_class_levels, dependent: :destroy
  has_many :abilities, -> { where(ability_type: 'class_feature') },
           foreign_key: :source, primary_key: :name, class_name: 'Ability'

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :hit_die, presence: true, inclusion: { in: [6, 8, 10, 12] }
  validates :primary_ability, presence: true

  # Scopes
  scope :by_hit_die, ->(die) { where(hit_die: die) }
  scope :with_spellcasting, -> { where.not(spellcasting: {}) }
  scope :with_primary_ability, ->(ability) { where("primary_ability @> ?", [ability].to_json) }

  # Methods
  def hit_die_string
    "d#{hit_die}"
  end

  def is_spellcaster?
    spellcasting.present? && spellcasting.any?
  end

  def spellcasting_ability
    spellcasting.dig('ability')
  end

  def ritual_casting?
    spellcasting.dig('ritual_casting') == true
  end

  def has_saving_throw_proficiency?(ability)
    saving_throw_proficiencies.include?(ability)
  end

  def has_skill_proficiency?(skill)
    skill_proficiencies.dig('available')&.include?(skill) || false
  end

  def skill_choices_count
    skill_proficiencies.dig('choose') || 0
  end

  def available_skills
    skill_proficiencies.dig('available') || []
  end

  def has_weapon_proficiency?(weapon_type)
    weapon_proficiencies.include?(weapon_type)
  end

  def has_armor_proficiency?(armor_type)
    armor_proficiencies.include?(armor_type)
  end

  def class_feature_at_level(level)
    class_features.dig(level.to_s) || {}
  end

  def meets_multiclass_requirements?(ability_scores)
    return true if multiclass_requirements.empty?

    multiclass_requirements.all? do |ability, required_score|
      ability_scores[ability].to_i >= required_score
    end
  end

  def display_primary_abilities
    return "None" if primary_ability.empty?
    primary_ability.join(" or ")
  end

  def display_saving_throws
    return "None" if saving_throw_proficiencies.empty?
    saving_throw_proficiencies.join(", ")
  end

  def display_hit_points
    "#{hit_die} + CON modifier per level"
  end

  def proficiency_bonus_at_level(level)
    case level
    when 1..4 then 2
    when 5..8 then 3
    when 9..12 then 4
    when 13..16 then 5
    when 17..20 then 6
    else 2
    end
  end
end
