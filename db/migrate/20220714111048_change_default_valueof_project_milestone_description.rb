class ChangeDefaultValueofProjectMilestoneDescription < ActiveRecord::Migration[6.1]
  def change
    change_column_default :project_milestones, :project_milestone_description, from: nil, to: ""
  end
end
