class RemoveProjectDateFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :project_date
  end
end
