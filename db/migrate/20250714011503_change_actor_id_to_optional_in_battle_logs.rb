class ChangeActorIdToOptionalInBattleLogs < ActiveRecord::Migration[7.1]
  def change
    change_column_null :battle_logs, :actor_id, true
  end
end
