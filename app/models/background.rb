class Background < ApplicationRecord
  has_many :characters, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :description, presence: true

  scope :with_skill, ->(skill) { where("skill_proficiencies ? :skill", skill: skill) }
  scope :with_language, ->(language) { where("language_proficiencies ? :language", language: language) }
  scope :with_tool, ->(tool) { where("tool_proficiencies ? :tool", tool: tool) }

  def grants_skill?(skill)
    skill_proficiencies.include?(skill)
  end

  def grants_language?(language)
    language_proficiencies.include?(language)
  end

  def grants_tool?(tool)
    tool_proficiencies.include?(tool)
  end

  def total_proficiencies
    skill_proficiencies.size + language_proficiencies.size + tool_proficiencies.size
  end

  def has_feature?
    feature_name.present? && feature_description.present?
  end

  def personality_trait_options
    suggested_characteristics.dig('personality_traits') || []
  end

  def ideal_options
    suggested_characteristics.dig('ideals') || []
  end

  def bond_options
    suggested_characteristics.dig('bonds') || []
  end

  def flaw_options
    suggested_characteristics.dig('flaws') || []
  end

  def random_personality_trait
    personality_trait_options.sample
  end

  def random_ideal
    ideal_options.sample
  end

  def random_bond
    bond_options.sample
  end

  def random_flaw
    flaw_options.sample
  end

  # Audit method for debugging and validation
  def audit
    {
      name: name,
      description: description,
      skills: skill_proficiencies,
      languages: language_proficiencies,
      tools: tool_proficiencies,
      equipment: equipment,
      feature: has_feature? ? { name: feature_name, description: feature_description } : nil,
      suggested_characteristics: suggested_characteristics
    }
  end

  # Summary hash for API/UI
  def summary_hash
    {
      id: id,
      name: name,
      description: description,
      skills: skill_proficiencies,
      languages: language_proficiencies,
      tools: tool_proficiencies,
      feature: feature_name
    }
  end
end
