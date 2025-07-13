class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :item_type
      t.jsonb :bonuses

      t.timestamps
    end
  end
end
