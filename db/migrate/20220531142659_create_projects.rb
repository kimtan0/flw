class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.date :project_date
      t.string :project_owner_id
      t.string :project_type
      t.string :project_description
      t.string :project_status
      t.string :project_milestone
      t.string :project_acceptance_user_id
      t.string :project_category
      t.string :project_detailed_category
      t.timestamps
    end
  end
end
