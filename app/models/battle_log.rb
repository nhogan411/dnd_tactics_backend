class BattleLog < ApplicationRecord
  belongs_to :battle
  belongs_to :actor, class_name: "Character", optional: true
  belongs_to :target, class_name: "Character", optional: true

  validates :action_type, presence: true
  validates :message, presence: true
end
