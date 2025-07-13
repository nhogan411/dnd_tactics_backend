class CreateCharacterClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :character_classes do |t|
      t.string :name
      t.jsonb :ability_requirements
      t.jsonb :bonuses

      t.timestamps
    end
  end
end
