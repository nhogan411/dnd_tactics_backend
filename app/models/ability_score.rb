class AbilityScore < ApplicationRecord
  belongs_to :character

  # Add modifier method that calculates D&D 5e modifier
  # Uses modified_score which includes equipment and racial/class bonuses
  def modifier
    (modified_score - 10) / 2
  end

  # Alias for backward compatibility
  def ability_modifier
    modifier
  end
end
