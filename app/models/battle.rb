class Battle < ApplicationRecord
  belongs_to :player_1, class_name: "User", foreign_key: "user_1_id"
  belongs_to :player_2, class_name: "User", foreign_key: "user_2_id"
  belongs_to :winner, class_name: "User", foreign_key: "winner_id", optional: true
  belongs_to :battle_board

  has_many :battle_participants, dependent: :destroy
  has_many :battle_logs, dependent: :destroy

  # Add aliases for backward compatibility
  alias_method :user_1, :player_1
  alias_method :user_2, :player_2
  alias_method :user_1=, :player_1=
  alias_method :user_2=, :player_2=

  # Helper methods for battle management
  def active_participants
    battle_participants.where(status: "active")
  end

  def team_1_participants
    battle_participants.where(team: 1)
  end

  def team_2_participants
    battle_participants.where(team: 2)
  end

  def current_participant
    participants_by_turn = battle_participants.order(:turn_order)
    current_index = (current_turn_index || 0) % participants_by_turn.count
    participants_by_turn[current_index]
  end
end
