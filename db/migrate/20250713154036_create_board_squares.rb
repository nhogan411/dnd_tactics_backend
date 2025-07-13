class CreateBoardSquares < ActiveRecord::Migration[8.0]
  def change
    create_table :board_squares do |t|
      t.references :battle_board, null: false, foreign_key: true
      t.integer :x
      t.integer :y
      t.integer :height
      t.integer :brightness
      t.string :surface_type

      t.timestamps
    end
  end
end
