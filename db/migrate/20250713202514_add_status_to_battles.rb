class AddStatusToBattles < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:battles, :status)
      add_column :battles, :status, :string, default: 'waiting'
    end
  end
end
