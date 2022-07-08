class CreateProjectMilestones < ActiveRecord::Migration[6.1]
  def change
    create_table :project_milestones do |t|
      t.integer :project_id
      t.integer :project_milestone_percentage, default: 0
      t.string :Project_milestone_description
      t.timestamps
    end
  end
end
