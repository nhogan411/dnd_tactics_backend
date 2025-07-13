class CreateBattleParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :battle_participants do |t|
      t.references :battle, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :team
      t.integer :current_hp
      t.string :status

      t.timestamps
    end
  end
end
