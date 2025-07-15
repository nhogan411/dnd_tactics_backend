class CreateCharacterSpells < ActiveRecord::Migration[7.1]
  def change
    create_table :character_spells do |t|
      t.references :character, null: false, foreign_key: true
      t.references :spell, null: false, foreign_key: true
      t.boolean :prepared, default: false # For prepared casters
      t.boolean :known, default: true # For known casters
      t.string :source, null: false, default: 'class' # 'class', 'race', 'feat', 'magic_item'
      t.integer :level_gained, null: false, default: 1
      t.jsonb :metadata, default: {} # For storing additional spell-specific data

      t.timestamps
    end

    add_index :character_spells, [:character_id, :spell_id], unique: true
    add_index :character_spells, :prepared
    add_index :character_spells, :known
    add_index :character_spells, :source
  end
end
