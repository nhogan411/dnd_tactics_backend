class AddLevelToCharacters < ActiveRecord::Migration[8.0]
  def change
    add_column :characters, :level, :integer
  end
end
