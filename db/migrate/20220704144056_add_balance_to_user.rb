class AddBalanceToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :balance, :decimal, :precision => 8, :scale => 2, :default => 0.00
  end
end
