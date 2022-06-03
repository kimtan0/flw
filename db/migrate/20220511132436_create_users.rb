class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :postcode
      t.string :phone_number
      t.string :country
      t.boolean :employer_status, default: false
      t.boolean :freelancer_status, default: false
      t.string :password_digest
      t.timestamps
    end
  end
end
