class Subrace < ApplicationRecord
  belongs_to :race
  has_many :characters, dependent: :destroy
end
