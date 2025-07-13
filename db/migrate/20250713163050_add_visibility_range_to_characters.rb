class AddVisibilityRangeToCharacters < ActiveRecord::Migration[8.0]
  def change
    add_column :characters, :visibility_range, :integer
  end
end
