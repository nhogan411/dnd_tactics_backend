class ChangeTargetIdToOptionalInBattleLogs < ActiveRecord::Migration[7.1]
  def change
    change_column_null :battle_logs, :target_id, true
  end
end
