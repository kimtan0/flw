class AddColumnsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :payment_type, :string
    add_column :projects, :project_price, :float
  end
end
