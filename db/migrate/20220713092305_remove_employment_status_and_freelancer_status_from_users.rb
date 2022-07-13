class RemoveEmploymentStatusAndFreelancerStatusFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :employer_status
    remove_column :users, :freelancer_status
  end
end
