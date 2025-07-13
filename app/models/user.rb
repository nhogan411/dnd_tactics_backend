class User < ApplicationRecord
  has_many :characters, dependent: :destroy
  has_many :battle_participants, dependent: :destroy
  has_many :battle_participant_selections, dependent: :destroy
  has_many :battles_as_player_1, class_name: "Battle", foreign_key: "user_1_id", dependent: :destroy
  has_many :battles_as_player_2, class_name: "Battle", foreign_key: "user_2_id", dependent: :destroy
  has_many :won_battles, class_name: "Battle", foreign_key: "winner_id", dependent: :nullify

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  # Optional: convenience method for all battles
  def battles
    Battle.where("user_1_id = ? OR user_2_id = ?", id, id)
  end
end
