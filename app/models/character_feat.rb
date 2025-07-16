class CharacterFeat < ApplicationRecord
  belongs_to :character
  belongs_to :feat

  validates :level_gained, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 20 }
  validates :character_id, uniqueness: { scope: :feat_id }

  scope :gained_at_level, ->(level) { where(level_gained: level) }
  scope :by_level, -> { order(:level_gained) }

  def gained_at_creation?
    level_gained == 1
  end

  def selected_ability_increase
    selected_options.dig('ability_increase')
  end

  def selected_skill
    selected_options.dig('skill')
  end

  def display_level_gained
    "Level #{level_gained}"
  end

  # Feat management
  def half_feat?
    feat.half_feat?
  end

  def full_feat?
    !half_feat?
  end

  def has_options?
    selected_options.present? && selected_options.any?
  end

  def ability_increase_applied?
    half_feat? && selected_ability_increase.present?
  end

  def ability_increased
    return nil unless ability_increase_applied?
    selected_ability_increase
  end

  def skill_proficiency_gained
    selected_options.dig('skill_proficiency')
  end

  def language_gained
    selected_options.dig('language')
  end

  def tool_proficiency_gained
    selected_options.dig('tool_proficiency')
  end

  def options_summary
    return "No options selected" unless has_options?

    summary = []
    summary << "#{ability_increased} +1" if ability_increase_applied?
    summary << "Skill: #{skill_proficiency_gained}" if skill_proficiency_gained
    summary << "Language: #{language_gained}" if language_gained
    summary << "Tool: #{tool_proficiency_gained}" if tool_proficiency_gained

    summary.join(", ")
  end

  def can_be_removed?
    # Generally feats can't be removed once taken, but this could be used for respec
    false
  end

  def benefits_active?
    # Check if the feat's benefits are currently active
    true
  end

  def prerequisites_still_met?
    feat.meets_prerequisites?(character)
  end

  # Audit and summary methods
  def audit
    {
      feat: feat.name,
      level_gained: level_gained,
      half_feat: half_feat?,
      selected_options: selected_options,
      options_summary: options_summary,
      prerequisites_met: prerequisites_still_met?,
      benefits_active: benefits_active?
    }
  end

  def summary_hash
    {
      id: id,
      feat_name: feat.name,
      level_gained: level_gained,
      half_feat: half_feat?,
      options: options_summary
    }
  end
end
