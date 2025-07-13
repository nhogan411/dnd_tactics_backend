class CreateCharacterClassLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :character_class_levels do |t|
      t.references :character, null: false, foreign_key: true
      t.references :character_class, null: false, foreign_key: true
      t.integer :level, default: 1
      t.timestamps
    end
  end
end
