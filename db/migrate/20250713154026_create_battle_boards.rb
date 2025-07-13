class CreateBattleBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :battle_boards do |t|
      t.string :name
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
