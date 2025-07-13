class BattleParticipantSelection < ApplicationRecord
  belongs_to :user
  belongs_to :battle
  belongs_to :character

  validate :battle_must_be_open

  def battle_must_be_open
    if battle.status != "waiting"
      errors.add(:battle, "is not accepting new participants")
    end
  end
end
