class CreateAbilityScores < ActiveRecord::Migration[8.0]
  def change
    create_table :ability_scores do |t|
      t.references :character, null: false, foreign_key: true
      t.string :score_type
      t.integer :base_score
      t.integer :modified_score

      t.timestamps
    end
  end
end
