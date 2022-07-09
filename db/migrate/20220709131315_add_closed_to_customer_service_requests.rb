class AddClosedToCustomerServiceRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_service_requests, :closed, :boolean, :default => FALSE
  end
end
