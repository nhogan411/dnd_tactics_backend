class AddMovementSpeedToCharacters < ActiveRecord::Migration[8.0]
  def change
    add_column :characters, :movement_speed, :integer
  end
end
