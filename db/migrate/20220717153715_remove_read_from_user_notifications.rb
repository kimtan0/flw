class RemoveReadFromUserNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_notifications, :read
  end
end
