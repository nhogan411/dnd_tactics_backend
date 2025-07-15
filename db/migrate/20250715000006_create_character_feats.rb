class CreateCharacterFeats < ActiveRecord::Migration[7.1]
  def change
    create_table :character_feats do |t|
      t.references :character, null: false, foreign_key: true
      t.references :feat, null: false, foreign_key: true
      t.integer :level_gained, default: 1
      t.jsonb :selected_options, default: {}

      t.timestamps
    end

    add_index :character_feats, [:character_id, :feat_id], unique: true
    add_index :character_feats, :level_gained
  end
end
