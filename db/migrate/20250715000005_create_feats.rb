class CreateFeats < ActiveRecord::Migration[7.1]
  def change
    create_table :feats do |t|
      t.string :name, null: false
      t.text :description
      t.jsonb :prerequisites, default: {}
      t.jsonb :benefits, default: {}
      t.jsonb :ability_score_increases, default: {}
      t.boolean :half_feat, default: false
      t.text :notes

      t.timestamps
    end

    add_index :feats, :name, unique: true
    add_index :feats, :prerequisites, using: :gin
    add_index :feats, :half_feat
  end
end
