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
end
