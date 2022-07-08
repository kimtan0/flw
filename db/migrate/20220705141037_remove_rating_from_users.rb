class RemoveRatingFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :rating
  end
end
