class CreateSubclasses < ActiveRecord::Migration[8.0]
  def change
    create_table :subclasses do |t|
      t.string :name
      t.references :character_class, null: false, foreign_key: true
      t.jsonb :bonuses

      t.timestamps
    end
  end
end
