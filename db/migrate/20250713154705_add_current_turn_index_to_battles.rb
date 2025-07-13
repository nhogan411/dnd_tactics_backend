class AddCurrentTurnIndexToBattles < ActiveRecord::Migration[8.0]
  def change
    add_column :battles, :current_turn_index, :integer
  end
end
