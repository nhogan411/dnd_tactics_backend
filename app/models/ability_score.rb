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

  # Returns the total modified score by summing base_score and all modifiers
  def modified_score
    base = self.base_score || 10
    total_mod = modifiers.sum { |mod| mod['amount'].to_i }
    base + total_mod
  end

  # Add a modifier to the breakdown
  def add_modifier(source:, amount:, reason: nil)
    self.modifiers ||= []
    self.modifiers << { 'source' => source, 'amount' => amount, 'reason' => reason }
    save
  end

  # Remove a modifier by source
  def remove_modifier(source)
    self.modifiers ||= []
    self.modifiers = modifiers.reject { |mod| mod['source'] == source }
    save
  end

  # Audit breakdown of all modifiers
  def modifier_breakdown
    breakdown = []
    breakdown << { source: 'Base', amount: base_score, reason: 'Initial value' }
    modifiers.each do |mod|
      breakdown << { source: mod['source'], amount: mod['amount'], reason: mod['reason'] }
    end
    breakdown
  end

  # Display breakdown as a string
  def breakdown_string
    modifier_breakdown.map { |b| "#{b[:source]}: #{b[:amount]} (#{b[:reason]})" }.join(' + ')
  end
end
