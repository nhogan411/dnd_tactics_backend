class AddInitiativeAndTurnToBattleParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :battle_participants, :initiative_roll, :integer
    add_column :battle_participants, :turn_order, :integer
  end
end
