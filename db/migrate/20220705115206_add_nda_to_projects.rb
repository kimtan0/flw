class AddNdaToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :NDA, :boolean, :default => FALSE
  end
end
