class BattleLog < ApplicationRecord
  belongs_to :battle
  belongs_to :actor, class_name: "BattleParticipant"
  belongs_to :target, class_name: "BattleParticipant", optional: true
end
