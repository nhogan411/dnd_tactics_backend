class AddBattleBoardToBattles < ActiveRecord::Migration[8.0]
  def change
    add_reference :battles, :battle_board, null: false, foreign_key: true
  end
end
