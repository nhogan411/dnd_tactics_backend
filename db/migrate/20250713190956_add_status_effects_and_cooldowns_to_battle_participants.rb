class AddStatusEffectsAndCooldownsToBattleParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :battle_participants, :status_effects, :json
    add_column :battle_participants, :cooldowns, :json
  end
end
