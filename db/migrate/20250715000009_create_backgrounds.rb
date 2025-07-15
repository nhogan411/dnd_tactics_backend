class CreateBackgrounds < ActiveRecord::Migration[7.1]
  def change
    create_table :backgrounds do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description, null: false
      t.jsonb :skill_proficiencies, default: [] # Array of skill names
      t.jsonb :language_proficiencies, default: [] # Array of language names
      t.jsonb :tool_proficiencies, default: [] # Array of tool names
      t.jsonb :equipment, default: {} # Starting equipment
      t.integer :starting_gold, default: 0
      t.text :feature_name, null: true
      t.text :feature_description, null: true
      t.jsonb :suggested_characteristics, default: {} # personality traits, ideals, bonds, flaws
      t.text :notes, null: true

      t.timestamps
    end

    add_index :backgrounds, :skill_proficiencies, using: :gin
    add_index :backgrounds, :language_proficiencies, using: :gin
    add_index :backgrounds, :tool_proficiencies, using: :gin
  end
end
