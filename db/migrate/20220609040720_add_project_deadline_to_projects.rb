class AddProjectDeadlineToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :project_deadline, :datetime
  end
end
