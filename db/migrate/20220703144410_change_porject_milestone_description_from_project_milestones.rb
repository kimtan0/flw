class ChangePorjectMilestoneDescriptionFromProjectMilestones < ActiveRecord::Migration[6.1]
  def change
    rename_column :project_milestones, :Project_milestone_description, :project_milestone_description
  end
end
