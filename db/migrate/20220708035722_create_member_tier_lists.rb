class CreateMemberTierLists < ActiveRecord::Migration[6.1]
  def change
    create_table :member_tier_lists do |t|
      t.integer :user_id
      t.decimal :total_amount, precision: 8, scale: 2, default: 0.00
      t.integer :current_tier_list, default: 0
      t.boolean :level_1_status, default: FALSE
      t.boolean :level_2_status, default: FALSE
      t.boolean :level_3_status, default: FALSE
      t.timestamps
    end
  end
end
