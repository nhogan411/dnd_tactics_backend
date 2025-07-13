class Character < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :subrace
  belongs_to :character_class
  belongs_to :subclass

  has_many :ability_scores, dependent: :destroy
  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items
  has_many :character_abilities, dependent: :destroy
  has_many :abilities, through: :character_abilities
  has_many :battle_participants, dependent: :destroy
  has_many :character_class_levels, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :level, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  validates :movement_speed, numericality: { only_integer: true, greater_than: 0 }
  validates :max_hp, numericality: { only_integer: true, greater_than: 0 }
  validates :visibility_range, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  # Helper methods to get specific ability scores
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

  # Calculate max HP based on character class and level
  def calculate_max_hp
    # Simple calculation - you can expand this later
    base_hp = 8  # Base HP (could be based on character class later)
    con_modifier = constitution_modifier
    level_val = self.level || 1

    base_hp + (con_modifier * level_val)
  end
end
