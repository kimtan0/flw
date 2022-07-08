class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :rating, :default => 0.0
      t.integer :rating_count, :default => 0
      t.timestamps
    end
  end
end
