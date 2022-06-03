class UserController < ApplicationController
  def Index
  end

  def project
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.to_h.merge(project_owner_id: cookies[:user_id], project_date: Time.now.strftime("%Y-%m-%d")))
    if @project.save
      redirect_to user_Index_path, flash: { info: "Project Created" }
    else
      puts "Project failed to create"
    end
  end


  private
  
  def project_params
    params.required(:project).permit(:project_name, :project_description,:project_category, :project_detailed_category, :project_type)
  end

end
