class AddBattleAbilityModifiersToBattleParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :battle_participants, :battle_ability_modifiers, :json
  end
end
