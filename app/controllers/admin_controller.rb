class AdminController < ApplicationController
 
  before_action :check_admin

  def index
    preprocessProject = Project.where(project_status: nil).or(Project.where(project_status: "In Progress"))
    if params["search"]
      if !params["search"]["PC"].blank? && !params["search"]["PDC"].blank?
        @filter = params["search"]["PC"].concat(params["search"]["PDC"]).flatten.reject(&:blank?)
        if @filter.empty?
          @project = preprocessProject
        else
          @project = preprocessProject.tagged_with(@filter, any: true)
        end
      end
    end
    
    if @project.blank?
      @project = preprocessProject
    end
  end

  def project_details
    @project = Project.find(params[:id])

    if @project.project_acceptance_user_id.nil?
      @user = User.find(@project.project_owner_id)
      rating = Rating.find_by(user_id: @project.project_owner_id)
    else
      @user = User.find(@project.project_acceptance_user_id)
      rating = Rating.find_by(user_id: @project.project_acceptance_user_id)
    end

    if rating.rating == 0 && rating.rating_count == 0
      @actual_rating = 0
      @actual_rating_count = 0
    elsif rating.rating == 0 && rating.rating_count != 0
      @actual_rating = 0
      @actual_rating_count = rating.rating_count
    else
      @actual_rating = (rating.rating / rating.rating_count).to_i
      @actual_rating_count = rating.rating_count
    end
  end

  def destroy
    project = Project.find(params[:id])
    project_price = project.project_price
    project_price_10 = project_price *10 /100
    owner_credit = Credit.find_by(user_id:project.project_owner_id)
    owner_credit.update(balance: owner_credit.balance + project_price_10, fixed_balance: owner_credit.fixed_balance - project_price_10)

    if !project.project_acceptance_user_id.nil?
      project_price_5 = project_price *5 /100
      freelancer_credit = Credit.find_by(user_id: project.project_acceptance_user_id)
      freelancer_credit.update(balance: freelancer_credit.balance + project_price_5)

    end

    project.delete
    ProjectMilestone.find_by(project_id: params[:id]).delete
    redirect_to admin_index_path, flash: { info: "Project has been deleted." }
  end

  def report_project
    redirect_to admin_index_path, flash: { info: "Project has been reported to management." }
  end

  def report_user
    redirect_to admin_index_path, flash: { info: "User has been reported to management." }
  end

  def profile
    @user = User.find(params[:id])
    rating = Rating.find_by(user_id: params[:id])
    if rating.rating == 0 && rating.rating_count == 0
      @actual_rating = 0
      @actual_rating_count = 0
    else
      @actual_rating = (rating.rating / rating.rating_count).to_i
      @actual_rating_count = rating.rating_count
    end
    @tier_list = MemberTierList.find_by(user_id: @user.id).current_tier_list
    @project_own = Project.where(project_owner_id: params[:id])
    @project_undertake = Project.where(project_acceptance_user_id: params[:id])
  end

  def report_request
    preporcessReportRequest = CustomerServiceRequest.where(closed: false)
    
    if params["search"]
      if !params["search"]["RC"].blank?
        @filter = params["search"]["RC"].flatten.reject(&:blank?)
        if @filter.empty?
          @report_request = preporcessReportRequest
        else
          @report_request = preporcessReportRequest.tagged_with(@filter, any: true)
        end
      end
    end
    
    if @report_request.blank?
      @report_request = preporcessReportRequest
    end

  end

  def report_request_details
    @report_request = CustomerServiceRequest.find(params[:id])
    @user = User.find(@report_request.user_id)
  end

  def complete_report_request
    CustomerServiceRequest.find(params[:id]).update(closed: true)
    redirect_to admin_report_request_path, flash: { info: "Request has been completed" }
  end

  def email_user  
    @id = User.find(params[:id])
  end

  def email_action
    email = User.find(params[:id]).email
    HomepageMailer.with(email: email, content: params[:EmailContent]).email_user.deliver_now
    redirect_to admin_email_user_path(:id => params[:id]), flash: { info: "Email has been sent to user." }
  end

  private

  def check_admin
    if !cookies[:admin_uuid].present?
      redirect_to home_login_path
    end
  end

end
