class Race < ApplicationRecord
  has_many :subraces, dependent: :destroy
  has_many :characters, dependent: :destroy

  validates :name, presence: true
end
