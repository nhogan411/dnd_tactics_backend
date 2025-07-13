class CreateAbilities < ActiveRecord::Migration[8.0]
  def change
    create_table :abilities do |t|
      t.string :name
      t.text :description
      t.string :class_name
      t.integer :level_required
      t.string :action_type
      t.integer :cooldown_turns

      t.timestamps
    end
  end
end
