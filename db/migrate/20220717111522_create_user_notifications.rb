class CreateUserNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_notifications do |t|
      t.integer :user_id
      t.string :title
      t.boolean :read
      t.timestamps
    end
  end
end
