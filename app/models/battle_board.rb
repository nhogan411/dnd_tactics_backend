class BattleBoard < ApplicationRecord
  has_many :board_squares, dependent: :destroy
  has_many :starting_squares, dependent: :destroy
  has_many :battles, dependent: :destroy
end
