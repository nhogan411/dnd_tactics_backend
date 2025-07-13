class CreateBattleParticipantSelections < ActiveRecord::Migration[8.0]
  def change
    create_table :battle_participant_selections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :battle, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end
