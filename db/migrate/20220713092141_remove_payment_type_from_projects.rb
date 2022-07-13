class RemovePaymentTypeFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :payment_type
  end
end
