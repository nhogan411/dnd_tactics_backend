class AddPositionToBattleParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :battle_participants, :pos_x, :integer
    add_column :battle_participants, :pos_y, :integer
  end
end
