class ChangeDefaultValueofUuidToNil < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :uuid, from: SecureRandom.uuid, to: nil
  end
end
