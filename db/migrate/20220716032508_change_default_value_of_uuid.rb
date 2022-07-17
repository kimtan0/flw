class ChangeDefaultValueOfUuid < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :uuid, from: nil, to: SecureRandom.uuid
  end
end
