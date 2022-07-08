class ChangeColumnInProject < ActiveRecord::Migration[6.1]
  def change
    change_column :projects, :project_deadline, :date
  end
end
