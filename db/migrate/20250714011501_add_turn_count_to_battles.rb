class AddTurnCountToBattles < ActiveRecord::Migration[7.1]
  def change
    add_column :battles, :turn_count, :integer, default: 1, null: false
  end
end
