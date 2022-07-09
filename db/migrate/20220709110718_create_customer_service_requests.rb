class CreateCustomerServiceRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_service_requests do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
