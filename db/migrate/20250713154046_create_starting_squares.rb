class CreateStartingSquares < ActiveRecord::Migration[8.0]
  def change
    create_table :starting_squares do |t|
      t.references :battle_board, null: false, foreign_key: true
      t.integer :x
      t.integer :y
      t.integer :team

      t.timestamps
    end
  end
end
