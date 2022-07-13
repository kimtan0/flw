class AddProjectAvailableDeadlineToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :project_available_deadline, :date
  end

end
