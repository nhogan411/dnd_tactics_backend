class Subclass < ApplicationRecord
  belongs_to :character_class
  has_many :characters, dependent: :destroy
end
