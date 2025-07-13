class Character < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :character_class

  serialize :ability_scores, Hash

  validates :name, presence: true, length: { maximum: 50 }
  validates :level, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  validates :movement_speed, numericality: { only_integer: true, greater_than: 0 }
  validate :validate_ability_scores
  validate :validate_race_and_class_compatibility

  before_validation :apply_race_ability_modifiers, on: :create

  private

    def validate_ability_scores
      required_abilities = %w[strength dexterity constitution intelligence wisdom charisma]
      missing = required_abilities - ability_scores.keys.map(&:downcase)
      errors.add(:ability_scores, "must include #{missing.join(', ')}") if missing.any?

      ability_scores.each do |k, v|
        errors.add(:ability_scores, "#{k} must be between 1 and 20") unless (1..20).include?(v.to_i)
      end
    end

    def validate_race_and_class_compatibility
      # For example, check if character_class has min ability requirements
      # Could add logic here to ensure min scores are met
    end

    def apply_race_ability_modifiers
      return unless race&.ability_score_modifiers.present? && ability_scores.present?

      race.ability_score_modifiers.each do |ability, mod|
        current = ability_scores[ability.downcase] || 0
        ability_scores[ability.downcase] = [ current + mod, 20 ].min
      end
    end

    # Add helper methods to get specific ability scores
    def strength
      ability_scores.find_by(score_type: "STR")&.modified_score || 10
    end

    def dexterity
      ability_scores.find_by(score_type: "DEX")&.modified_score || 10
    end

    def constitution
      ability_scores.find_by(score_type: "CON")&.modified_score || 10
    end

    def intelligence
      ability_scores.find_by(score_type: "INT")&.modified_score || 10
    end

    def wisdom
      ability_scores.find_by(score_type: "WIS")&.modified_score || 10
    end

    def charisma
      ability_scores.find_by(score_type: "CHA")&.modified_score || 10
    end

    # Helper method to get ability modifier (for D&D mechanics)
    # Uses modified_score which includes equipment and racial/class bonuses
    def ability_modifier(score)
      (score - 10) / 2
    end

    # Convenience methods for ability modifiers (using modified_score)
    def strength_modifier
      ability_scores.find_by(score_type: "STR")&.modifier || ability_modifier(10)
    end

    def dexterity_modifier
      ability_scores.find_by(score_type: "DEX")&.modifier || ability_modifier(10)
    end

    def constitution_modifier
      ability_scores.find_by(score_type: "CON")&.modifier || ability_modifier(10)
    end

    def intelligence_modifier
      ability_scores.find_by(score_type: "INT")&.modifier || ability_modifier(10)
    end

    def wisdom_modifier
      ability_scores.find_by(score_type: "WIS")&.modifier || ability_modifier(10)
    end

    def charisma_modifier
      ability_scores.find_by(score_type: "CHA")&.modifier || ability_modifier(10)
    end

    def max_hp
      # Simple calculation for now - you can expand this later
      base_hp = 8  # Base HP (could be based on character class later)
      con_modifier = constitution_modifier
      level = self.level || 1

      base_hp + (con_modifier * level)
    end
end
