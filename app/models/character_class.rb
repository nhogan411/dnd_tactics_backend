class CharacterClass < ApplicationRecord
  has_many :subclasses, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :character_class_levels, dependent: :destroy
end
