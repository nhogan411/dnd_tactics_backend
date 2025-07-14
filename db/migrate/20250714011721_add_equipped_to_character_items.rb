class AddEquippedToCharacterItems < ActiveRecord::Migration[8.0]
  def change
    add_column :character_items, :equipped, :boolean
  end
end
