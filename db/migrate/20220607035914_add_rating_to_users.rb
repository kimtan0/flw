class AddRatingToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :rating, :float, :default => 0.0
  end
end
