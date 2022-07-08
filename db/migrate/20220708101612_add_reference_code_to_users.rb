class AddReferenceCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reference_code, :string
  end
end
