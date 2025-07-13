class AddDefaultVisibilityRangeToRaces < ActiveRecord::Migration[8.0]
  def change
    add_column :races, :default_visibility_range, :integer
  end
end
