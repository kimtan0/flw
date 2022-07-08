class RemovePorjectMilestoneFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :project_milestone
  end
end
