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
end
