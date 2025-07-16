class Race < ApplicationRecord
  has_many :subraces, dependent: :destroy
  has_many :characters, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :size, inclusion: { in: %w[Tiny Small Medium Large Huge Gargantuan] }
  validates :speed, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :by_size, ->(size) { where(size: size) }
  scope :with_trait, ->(trait) { where("traits ? :trait", trait: trait) }
  scope :with_language, ->(language) { where("languages @> ?", [language].to_json) }

  # Methods
  def has_trait?(trait)
    traits.key?(trait) && traits[trait]
  end

  def knows_language?(language)
    languages.include?(language)
  end

  def has_proficiency?(type, proficiency)
    proficiencies.dig(type)&.include?(proficiency) || false
  end

  def trait_description(trait)
    return nil unless has_trait?(trait)
    traits[trait].is_a?(Hash) ? traits[trait]['description'] : nil
  end

  def display_languages
    return "None" if languages.empty?
    languages.join(", ")
  end

  def display_size_and_speed
    "#{size}, #{speed} ft"
  end

  # Racial trait helpers
  def darkvision_range
    return 0 unless has_trait?('darkvision')
    traits['darkvision']['range'] || 60
  end

  def has_darkvision?
    has_trait?('darkvision')
  end

  def has_fey_ancestry?
    has_trait?('fey_ancestry')
  end

  def has_magic_resistance?
    has_trait?('magic_resistance')
  end

  def natural_armor_bonus
    return 0 unless has_trait?('natural_armor')
    traits['natural_armor']['bonus'] || 0
  end

  def breath_weapon_damage
    return nil unless has_trait?('breath_weapon')
    traits['breath_weapon']['damage']
  end

  def damage_resistance
    return [] unless has_trait?('damage_resistance')
    traits['damage_resistance']['types'] || []
  end

  def damage_immunity
    return [] unless has_trait?('damage_immunity')
    traits['damage_immunity']['types'] || []
  end

  def spell_like_abilities
    return [] unless has_trait?('spell_like_abilities')
    traits['spell_like_abilities']['spells'] || []
  end

  # Character creation helpers
  def available_subraces
    subraces.order(:name)
  end

  def default_subrace
    subraces.first
  end

  def grants_skill_proficiency?(skill)
    has_proficiency?('skills', skill)
  end

  def grants_weapon_proficiency?(weapon)
    has_proficiency?('weapons', weapon)
  end

  def grants_tool_proficiency?(tool)
    has_proficiency?('tools', tool)
  end

  def total_proficiencies
    skill_count = proficiencies.dig('skills')&.size || 0
    weapon_count = proficiencies.dig('weapons')&.size || 0
    tool_count = proficiencies.dig('tools')&.size || 0
    skill_count + weapon_count + tool_count
  end

  def common_traits
    %w[darkvision keen_senses fey_ancestry trance brave halfling_nimbleness stonecunning draconic_ancestry]
  end

  def unique_traits
    traits.keys - common_traits
  end

  # Audit and summary methods
  def audit
    {
      name: name,
      size: size,
      speed: speed,
      languages: languages,
      proficiencies: proficiencies,
      traits: traits,
      darkvision: has_darkvision? ? darkvision_range : nil,
      damage_resistance: damage_resistance,
      damage_immunity: damage_immunity,
      subraces: subraces.map(&:name),
      unique_traits: unique_traits
    }
  end

  def summary_hash
    {
      id: id,
      name: name,
      size: size,
      speed: speed,
      languages: languages,
      darkvision: has_darkvision? ? darkvision_range : nil,
      subraces: subraces.map(&:name)
    }
  end
end
