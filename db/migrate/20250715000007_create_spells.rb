class CreateSpells < ActiveRecord::Migration[7.1]
  def change
    create_table :spells do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description, null: false
      t.integer :level, null: false, default: 0 # 0 for cantrips, 1-9 for spell levels
      t.string :school, null: false # Evocation, Conjuration, etc.
      t.string :casting_time, null: false
      t.string :range, null: false
      t.string :duration, null: false
      t.jsonb :components, default: {} # verbal, somatic, material
      t.string :material_components, null: true
      t.boolean :concentration, default: false
      t.boolean :ritual, default: false
      t.text :at_higher_levels, null: true
      t.jsonb :class_lists, default: [] # Which classes can learn this spell
      t.jsonb :damage, default: {} # damage dice, type, etc.
      t.jsonb :effects, default: {} # healing, conditions, etc.
      t.string :saving_throw, null: true # Which save if any
      t.string :attack_type, null: true # "spell", "ranged", "melee", etc.
      t.text :notes, null: true

      t.timestamps
    end

    add_index :spells, :level
    add_index :spells, :school
    add_index :spells, :class_lists, using: :gin
    add_index :spells, :concentration
    add_index :spells, :ritual
  end
end
