class CreateBattles < ActiveRecord::Migration[8.0]
  def change
    create_table :battles do |t|
      t.references :user_1, null: false, foreign_key: true
      t.references :user_2, null: false, foreign_key: true
      t.references :winner, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
