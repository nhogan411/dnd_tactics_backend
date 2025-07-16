class AddModifiersToAbilityScores < ActiveRecord::Migration[7.1]
  def change
    add_column :ability_scores, :modifiers, :jsonb, default: []
    add_index :ability_scores, :modifiers, using: :gin
  end
end
