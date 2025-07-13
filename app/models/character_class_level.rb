class CharacterClassLevel < ApplicationRecord
  belongs_to :character
  belongs_to :character_class

  validates :level, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
end
