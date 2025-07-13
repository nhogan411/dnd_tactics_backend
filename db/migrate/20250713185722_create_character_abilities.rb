class CreateCharacterAbilities < ActiveRecord::Migration[8.0]
  def change
    create_table :character_abilities do |t|
      t.references :character, null: false, foreign_key: true
      t.references :ability, null: false, foreign_key: true
      t.integer :uses_remaining

      t.timestamps
    end
  end
end
