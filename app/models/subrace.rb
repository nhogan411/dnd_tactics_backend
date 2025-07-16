class Subrace < ApplicationRecord
  belongs_to :race
  has_many :characters, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :size, inclusion: { in: %w[Tiny Small Medium Large Huge Gargantuan] }, allow_nil: true
  validates :speed, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes
  scope :by_size, ->(size) { where(size: size) }
  scope :with_trait, ->(trait) { where("traits ? :trait", trait: trait) }
  scope :with_spell, ->(spell) { where("spells @> ?", [spell].to_json) }

  # Methods
  def effective_size
    size || race.size
  end

  def effective_speed
    speed || race.speed
  end

  def effective_languages
    (race.languages + (languages || [])).uniq
  end

  def effective_proficiencies
    race_profs = race.proficiencies || {}
    subrace_profs = proficiencies || {}

    # Merge proficiencies, combining arrays for each type
    merged = race_profs.dup
    subrace_profs.each do |type, profs|
      merged[type] = (merged[type] || []) + profs
      merged[type].uniq!
    end
    merged
  end

  def effective_traits
    race_traits = race.traits || {}
    subrace_traits = traits || {}
    race_traits.merge(subrace_traits)
  end

  def has_trait?(trait)
    effective_traits.key?(trait) && effective_traits[trait]
  end

  def knows_language?(language)
    effective_languages.include?(language)
  end

  def has_proficiency?(type, proficiency)
    effective_proficiencies.dig(type)&.include?(proficiency) || false
  end

  def racial_spells
    spells || []
  end

  def ability_score_modifiers
    ability_modifiers || {}
  end

  def display_ability_modifiers
    return "None" if ability_score_modifiers.empty?
    ability_score_modifiers.map { |ability, mod| "#{ability} #{mod >= 0 ? '+' : ''}#{mod}" }.join(", ")
  end

  def display_languages
    return "None" if effective_languages.empty?
    effective_languages.join(", ")
  end

  # Subrace-specific helpers
  def total_ability_bonuses
    ability_score_modifiers.values.sum
  end

  def primary_ability_bonus
    ability_score_modifiers.max_by { |_, value| value }
  end

  def grants_spells?
    racial_spells.any?
  end

  def innate_spellcasting?
    grants_spells?
  end

  def spell_count
    racial_spells.size
  end

  def unique_traits
    subrace_traits = traits || {}
    race_traits = race.traits || {}

    # Find traits that are unique to this subrace
    subrace_traits.keys - race_traits.keys
  end

  def inherited_traits
    subrace_traits = traits || {}
    race_traits = race.traits || {}

    # Find traits that are inherited from race
    subrace_traits.keys & race_traits.keys
  end

  def new_proficiencies
    race_profs = race.proficiencies || {}
    subrace_profs = proficiencies || {}

    new_profs = {}
    subrace_profs.each do |type, profs|
      race_type_profs = race_profs[type] || []
      new_profs[type] = profs - race_type_profs
    end

    new_profs.reject { |_, profs| profs.empty? }
  end

  def additional_languages
    (languages || []) - race.languages
  end

  def speed_modifier
    return 0 unless speed
    speed - race.speed
  end

  def has_speed_modifier?
    speed_modifier != 0
  end

  def size_change?
    size && size != race.size
  end

  # Character creation helpers
  def recommended_classes
    # Simple recommendations based on ability score bonuses
    recommendations = []

    ability_score_modifiers.each do |ability, bonus|
      next if bonus <= 0

      case ability
      when 'STR'
        recommendations += ['Fighter', 'Barbarian', 'Paladin']
      when 'DEX'
        recommendations += ['Rogue', 'Ranger', 'Monk']
      when 'CON'
        recommendations += ['Barbarian', 'Fighter']
      when 'INT'
        recommendations += ['Wizard']
      when 'WIS'
        recommendations += ['Cleric', 'Druid', 'Ranger']
      when 'CHA'
        recommendations += ['Bard', 'Sorcerer', 'Warlock', 'Paladin']
      end
    end

    recommendations.uniq
  end

  def synergy_score_with_class(class_name)
    # Calculate how well this subrace synergizes with a given class
    score = 0

    # Check ability score bonuses
    case class_name.downcase
    when 'fighter', 'barbarian', 'paladin'
      score += ability_score_modifiers['STR'] || 0
    when 'rogue', 'ranger', 'monk'
      score += ability_score_modifiers['DEX'] || 0
    when 'wizard'
      score += ability_score_modifiers['INT'] || 0
    when 'cleric', 'druid'
      score += ability_score_modifiers['WIS'] || 0
    when 'bard', 'sorcerer', 'warlock'
      score += ability_score_modifiers['CHA'] || 0
    end

    # Bonus for Constitution (helpful for all classes)
    score += (ability_score_modifiers['CON'] || 0) * 0.5

    score
  end

  # Audit and summary methods
  def audit
    {
      name: name,
      race: race.name,
      size: effective_size,
      speed: effective_speed,
      languages: effective_languages,
      proficiencies: effective_proficiencies,
      traits: effective_traits,
      ability_modifiers: ability_score_modifiers,
      spells: racial_spells,
      unique_traits: unique_traits,
      new_proficiencies: new_proficiencies,
      additional_languages: additional_languages,
      recommended_classes: recommended_classes
    }
  end

  def summary_hash
    {
      id: id,
      name: name,
      race: race.name,
      size: effective_size,
      speed: effective_speed,
      ability_modifiers: display_ability_modifiers,
      languages: display_languages,
      spells: racial_spells,
      recommended_classes: recommended_classes.first(3)
    }
  end
end
