class AddDefaultValueToUserNotifications < ActiveRecord::Migration[6.1]
  def change
    change_column_default :user_notifications, :title, from: nil, to: ""
    change_column_default :user_notifications, :read, from: nil, to: FALSE

  end
end
