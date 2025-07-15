class AddBackgroundToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_reference :characters, :background, null: true, foreign_key: true

    # Add background-specific character traits
    add_column :characters, :personality_traits, :text, null: true
    add_column :characters, :ideals, :text, null: true
    add_column :characters, :bonds, :text, null: true
    add_column :characters, :flaws, :text, null: true

    # Add spell slot usage tracking
    add_column :characters, :spell_slots_used, :jsonb, default: {}

    # Add attunement tracking
    add_column :characters, :attuned_items, :jsonb, default: []
    add_column :characters, :attunement_slots, :integer, default: 3

    # Add death saves
    add_column :characters, :death_save_successes, :integer, default: 0
    add_column :characters, :death_save_failures, :integer, default: 0

    # Add hit dice tracking
    add_column :characters, :hit_dice_used, :jsonb, default: {}

    add_index :characters, :spell_slots_used, using: :gin
    add_index :characters, :attuned_items, using: :gin
    add_index :characters, :hit_dice_used, using: :gin
  end
end
