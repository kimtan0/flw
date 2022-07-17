class RemoveTitleFromUserNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_notifications, :title
  end
end
