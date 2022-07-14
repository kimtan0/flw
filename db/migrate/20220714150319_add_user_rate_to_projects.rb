class AddUserRateToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :user_rate, :boolean, :default => FALSE
  end
end
