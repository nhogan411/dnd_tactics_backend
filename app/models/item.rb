class Item < ApplicationRecord
  has_many :character_items, dependent: :destroy
  has_many :characters, through: :character_items
end
