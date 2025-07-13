class CreateSubraces < ActiveRecord::Migration[8.0]
  def change
    create_table :subraces do |t|
      t.string :name
      t.references :race, null: false, foreign_key: true
      t.jsonb :ability_modifiers

      t.timestamps
    end
  end
end
