class CreateBattles < ActiveRecord::Migration[8.0]
  def change
    create_table :battles do |t|
      t.references :user_1, foreign_key: { to_table: :users }, null: false
      t.references :user_2, foreign_key: { to_table: :users }, null: false
      t.references :winner, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end
  end
end
