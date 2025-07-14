class AddEquippedToCharacterItems < ActiveRecord::Migration[7.1]
  def change
    add_column :character_items, :equipped, :boolean, default: false, null: false
  end
end
