class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true
      t.references :subrace, null: false, foreign_key: true
      t.references :character_class, null: false, foreign_key: true
      t.references :subclass, null: false, foreign_key: true
      t.integer :max_hp

      t.timestamps
    end
  end
end
