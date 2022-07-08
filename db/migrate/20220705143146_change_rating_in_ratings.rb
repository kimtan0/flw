class ChangeRatingInRatings < ActiveRecord::Migration[6.1]
  def change
    change_column :ratings, :rating, :decimal, :default => 0.0
  end
end
