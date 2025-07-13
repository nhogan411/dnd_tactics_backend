class User < ApplicationRecord
  has_many :characters
  has_many :battle_participants
  has_many :battles_as_player_1, class_name: "Battle", foreign_key: "user_1_id"
  has_many :battles_as_player_2, class_name: "Battle", foreign_key: "user_2_id"

  # Optional: convenience method for all battles
  def battles
    Battle.where("user_1_id = ? OR user_2_id = ?", id, id)
  end
end
