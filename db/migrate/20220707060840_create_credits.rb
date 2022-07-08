class CreateCredits < ActiveRecord::Migration[6.1]
  def change
    create_table :credits do |t|
      t.integer :user_id
      t.decimal :balance, precision: 8, scale: 2, default: 0.00
      t.decimal :fixed_balance, precision: 8, scale: 2, default: 0.00
      t.timestamps
    end
  end
end
