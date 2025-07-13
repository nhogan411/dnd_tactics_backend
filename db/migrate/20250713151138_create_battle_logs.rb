class CreateBattleLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :battle_logs do |t|
      t.references :battle, null: false, foreign_key: true
      t.references :actor, foreign_key: { to_table: :characters }, null: false
      t.references :target, null: false, foreign_key: { to_table: :characters }
      t.string :action_type
      t.jsonb :result_data
      t.string :message

      t.timestamps
    end
  end
end
