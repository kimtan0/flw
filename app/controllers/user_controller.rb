class UserController < ApplicationController

  before_action :check_user, only: [:project, :project_category, :accept_project, :project_details, :my_project, :my_account, :customer_service_category, :customer_service, :chat]
  before_action :topup_status, only: [:my_account]
  before_action :chat_presence, only: [:project, :project_category, :accept_project, :project_details, :my_project, :my_account, :customer_service_category, :customer_service, :chat]

  def Index
    preprocessProject = Project.where(project_acceptance_user_id: nil).or(Project.where(project_type: 'Bid').and(Project.where("project_available_deadline > ?", Date.today)))
    
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
    
    if cookies[:project_category].present?
      cookies.delete :project_category
    end


    if cookies[:user_uuid].present?
      user = User.find_by(uuid: cookies[:user_uuid])
      notifications = UserNotification.where(user_id: user.id).order(created_at: :desc).limit(20)
      noti = UserNotification.find_by(user_id: user.id)
      if !notifications.blank?
        @notifications = notifications
        user = User.find(noti.user_id)
        @name = user.first_name.to_s + " " + user.last_name.to_s
      end
    end

  end

  def project_category
    @firstproject = Project.new
  end

  def project
    @project = Project.new
    @project_category = params[:project][:project_category].downcase
    cookies[:project_category] = @project_category
  end

  def create
    project_price = (params[:project][:project_price]).to_i
    deposit_amount = project_price *10 / 100
    user = User.find_by(uuid: cookies[:user_uuid])
    credit = Credit.find_by(user_id: user.id)
    credit_balance  = credit.balance

    if credit_balance <= deposit_amount
      redirect_to user_Index_path, flash: { notice: "Insufficient Credit Balance, 10% of project price needs act as a deposit." }
      return
    else
      credit_balance -= deposit_amount
      fixed_balance = credit.fixed_balance + deposit_amount
      credit.update(balance: credit_balance, fixed_balance: fixed_balance)
    end

    if params[:project][:NDA] == "0"
      nda = FALSE
    else
      nda = TRUE
    end
    
    @project = Project.new(project_params.to_h.merge(
      project_owner_id: user.id, 
      project_category: cookies[:project_category], 
      project_detailed_category: params[:projectDetaildCategory].downcase,
      NDA: nda
      ))
    
    if @project.save
      project_milestone = ProjectMilestone.new(project_id: @project.id)
      project_milestone.save
      @project.avatar.attach(params[:project][:avatar])
      @project.category_list.add(@project.project_category) 
      @project.detailed_category_list.add(@project.project_detailed_category) 
      @project.save
      cookies.delete :project_category
      redirect_to user_Index_path, flash: { info: "Project Created" }
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

    if (@project.project_available_deadline - Date.today).to_i > 0
      @available_deadline = (@project.project_available_deadline - Date.today).to_i
    else
      @available_deadline = 0
    end

    if (@project.project_deadline - Date.today).to_i > 0
      @deadline = (@project.project_deadline - Date.today).to_i
    else
      @deadline = 0
    end

    user = User.find_by(uuid: cookies[:user_uuid])
    if cookies[:user_uuid].present? && user.id.to_i == @project.project_owner_id.to_i
      @user_status = "true"
    end

    pm = ProjectMilestone.find_by(project_id: params[:id])
    @width = pm.project_milestone_percentage
    @description = pm.project_milestone_description
  end

  def accept_project
    project = Project.find(params[:id])
    user = User.find_by(uuid: cookies[:user_uuid])
    project.update(project_status: "In Progress", project_acceptance_user_id: user.id)
    redirect_to user_Index_path, flash: { info: "Project has been accepted" }
  end

  def project_edit
    @project = Project.find(params[:id])
  end

  def edit
    project = Project.find(params[:id])
    project.update(
      project_name: project_params[:project_name], 
      project_description: project_params[:project_description], 
      project_detailed_category: params[:projectDetaildCategory].downcase, 
      project_type: project_params[:project_type], 
      project_price: project_params[:project_price],
      project_deadline: project_params[:project_deadline]
    )
    redirect_to user_Index_path, flash: { info: "Project has been updated" }
  end

  def destroy
    project = Project.find(params[:id])
    project_price = project.project_price
    project_price_10 = project_price *10 /100

    if project.project_acceptance_user_id.nil?
      owner_credit = Credit.find_by(user_id:project.project_owner_id)
      owner_credit.update(balance: owner_credit.balance + project_price_10, fixed_balance: owner_credit.fixed_balance - project_price_10)
      project.delete
      ProjectMilestone.find_by(project_id: params[:id]).delete
      redirect_to user_Index_path, flash: { info: "Project has been deleted" }

    else
      project_price_5 = project_price *5 /100
      owner_credit = Credit.find_by(user_id:project.project_owner_id)
      freelancer_credit = Credit.find_by(user_id: project.project_acceptance_user_id)
      owner_credit.update(balance: owner_credit.balance + project_price_5, fixed_balance: owner_credit.fixed_balance - project_price_10)
      freelancer_credit.update(balance: freelancer_credit.balance + project_price_5)
      project.delete
      ProjectMilestone.find_by(project_id: params[:id]).delete
      redirect_to user_Index_path, flash: { flash: "Project has been deleted, 5% of the project price has been refunded, 5% penalty fee has been paid." }
    end
  end

  def bid
    user = User.find_by(uuid: cookies[:user_uuid])
    project = Project.find_by(id: params[:projectId])
    credit = Credit.find_by(user_id: project.project_owner_id)
    project_price = project.project_price
    project_original_price_10 = project_price *10 /100
    preprocess_project_new_price_10 = (params[:project_price]).to_i
    project_new_price_10 = preprocess_project_new_price_10 *10 /100
    credit.update(balance: credit.balance + project_original_price_10 - project_new_price_10, fixed_balance: credit.fixed_balance - project_original_price_10 + project_new_price_10)
    project.update(project_price: params[:project_price], project_acceptance_user_id: user.id)
    redirect_to user_Index_path, flash: { info: "Successfully bid on Project" }
  end

  def my_project
    @user = User.find_by(uuid: cookies[:user_uuid]) 
    @project = Project.where(project_owner_id: @user.id)
  end

  def my_account
    @user = User.find_by(uuid: cookies[:user_uuid])
    credit = Credit.find_by(user_id: @user.id)
    balance = credit.balance.to_s
    fixed_balance = credit.fixed_balance.to_s
    @balance =  "$" + balance
    @fixed_balance = "$" + fixed_balance
    @tier_list = MemberTierList.find_by(user_id: @user.id).current_tier_list
    @reference_code = @user.reference_code
  end

  def my_accepted_project
    user = User.find_by(uuid: cookies[:user_uuid])
    @project = Project.where(project_acceptance_user_id: user.id)
  end

  def accepted_project_details
    @project = Project.find(params[:id])
    @deadline = (@project.project_deadline - Date.today).to_i
    pm = ProjectMilestone.find_by(project_id: params[:id])
    @width = pm.project_milestone_percentage
    @description = pm.project_milestone_description
    @user = User.find(@project.project_owner_id)
    rating = Rating.find_by(user_id: @project.project_owner_id)

    if rating.rating == 0 && rating.rating_count == 0
      @actual_rating = 0
      @actual_rating_count = 0
    else
      @actual_rating = (rating.rating / rating.rating_count).to_i
      @actual_rating_count = rating.rating_count
    end
    
  end

  def update_accepted_project_details
    pm = ProjectMilestone.find_by(project_id: params[:projectId])
    milestone_description = pm.project_milestone_description + " " + params[:newprojectprogressdetails]
    pm.update(project_milestone_percentage: params[:project_milestone], project_milestone_description: milestone_description)
    redirect_to user_my_account_my_accepted_project_path, flash: { info: "Successfully updated Project Progress" }
  end

  def cancel_accepted_project_confirmation
  end

  def cancel_accepted_project
    project = Project.find(params[:id])
    project_price = project.project_price
    project_price_10 = project_price *10 /100
    project_price_5 = project_price *5 /100
    owner_credit = Credit.find_by(user_id:project.project_owner_id)
    freelancer_credit = Credit.find_by(user_id: project.project_acceptance_user_id)

    if freelancer_credit.balance <= project_price_5
      redirect_to user_my_account_my_accepted_project_path, flash: { notice: "Project failed to cancel, insufficient balance to cancel project. Your balance needs to be at least 5% of the project price." }
    else
      freelancer_credit_balance = freelancer_credit.balance - project_price_5
      freelancer_credit.update(balance: freelancer_credit_balance)
      owner_credit_balance = owner_credit.balance + project_price_5
      owner_credit.update(balance: owner_credit_balance)
      project.update(project_status: nil, project_acceptance_user_id: nil)
      redirect_to user_my_account_my_accepted_project_path, flash: { info: "Project has been canceled" }
    end
  end

  def complete_project_confirmation
  end

  def complete_project
    project = Project.find(params[:id])
    rating = Rating.find_by(user_id: project.project_owner_id)
    rating_count = rating.rating_count + 1
    actual_rating = rating.rating + params[:rate].to_i
    rating.update(rating: actual_rating, rating_count: rating_count)
    project.update(project_status: "Completed")
    ProjectMilestone.find_by(project_id: params[:id]).update(project_milestone_percentage: 100)
    redirect_to user_Index_path, flash: { info: "Project has been completed" }
  end


  def rate_freelancer
    project = Project.find(params[:id])
    project_price = project.project_price
    credit = Credit.find_by(user_id: project.project_owner_id)
    fixed_balance = credit.fixed_balance
    balance = credit.balance
    project_price_10 = project_price *10 /100
    project_price_90 = project_price *90 /100
    project_price_02 = project_price *2 /100
    if fixed_balance <= project_price_10 || balance <= project_price_90
      redirect_to user_Index_path, flash: { notice: "Insufficient Credit Balance, please topup." }
      return
    else
      fixed_balance -= project_price_10
      balance -= project_price_90
      credit.update(balance: balance, fixed_balance: fixed_balance)
      freelancer = Credit.find_by(user_id: project.project_acceptance_user_id)
      freelancer.update(balance: freelancer.balance + project_price - project_price_02)
      project.update(user_rate: TRUE)
    end

    project_owner_tier = MemberTierList.find_by(user_id: project.project_owner_id)
    freelancer_tier = MemberTierList.find_by(user_id: project.project_acceptance_user_id)
    project_owner_amount = project_owner_tier.total_amount + project_price
    freelancer_amount = freelancer_tier.total_amount + project_price
    project_owner_tier.update(total_amount: project_owner_amount)
    freelancer_tier.update(total_amount: freelancer_amount)
    tier_list_reward(project_owner_tier)
    tier_list_reward(freelancer_tier)
    rating = Rating.find_by(user_id: project.project_acceptance_user_id)
    rating_count = rating.rating_count + 1
    actual_rating = rating.rating + params[:rate].to_i
    rating.update(rating: actual_rating, rating_count: rating_count)
    redirect_to user_Index_path, flash: { info: "Freelancer has been rated and payment has been made"}

  end

  def tier_list_reward(tier)
    if tier.total_amount >= 2000 
      tier_list_reward_selection(tier, 500)
    elsif tier.total_amount >= 10000
      tier_list_reward_selection(tier, 2500)
    elsif tier.total_amount >= 20000
      tier_list_reward_selection(tier, 5000)
    end
  end

  def tier_list_reward_selection(tier, reward)
    if tier.level_1_status == false
      credit = Credit.find_by(user_id: tier.user_id)
      credit.update(balance: credit.balance + reward)
      tier.update(level_1_status: true, current_tier_list: 1)
    elsif tier.level_2_status == false
      credit = Credit.find_by(user_id: tier.user_id)
      credit.update(balance: credit.balance + reward)
      tier.update(level_2_status: true, current_tier_list: 2)
    elsif tier.level_3_status == false
      credit = Credit.find_by(user_id: tier.user_id)
      credit.update(balance: credit.balance + reward)
      tier.update(level_3_status: true, current_tier_list: 3)
    end
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

  def topup
    @user = User.find_by(uuid: cookies[:user_uuid])
    credit = Credit.find_by(user_id: @user.id)
    balance = credit.balance.to_s
    fixed_balance = credit.fixed_balance.to_s
    @balance =  "$" + balance
    @fixed_balance = "$" + fixed_balance
  end

  def top_up_process
    user = User.find_by(uuid: cookies[:user_uuid])
    name = user.first_name + " " + user.last_name
    amount = params[:amount].to_i
    amount = amount *100
    bill_generator("Email to user", "Email Title", amount, name, user.email, user.phone_number)
  end

  def bill_url(billcode)
    cookies[:topup_status] = "1"
    url = "https://dev.toyyibpay.com/" + billcode
    redirect_to url
  end

  #https://freelancer-kim1.herokuapp.com/user/my_account
  #http://localhost:3000/user/my_account
  def bill_generator(bill_name, bill_description, amount, name, email, phone_number)

    uri = URI.parse("https://dev.toyyibpay.com/index.php/api/createBill")
    http = Net::HTTP.post_form(uri, 'userSecretKey'=> ENV['PAYMENT_GATEWAY_USER_KEY'],
      'categoryCode'=> ENV['PAYMENT_GATEWAY_CATEGORY_CODE'],
      'billName'=> bill_name,
      'billDescription'=> bill_description,
      'billPriceSetting'=>1,
      'billPayorInfo'=>1,
      'billAmount'=> amount,
      'billReturnUrl'=> "https://freelancer-kim1.herokuapp.com/user/my_account",
      'billTo'=> name,
      'billEmail'=> email,
      'billPhone'=> phone_number,
      'billSplitPayment'=>0,
      'billSplitPaymentArgs'=>'',
      'billPaymentChannel'=>'2',
      'billContentEmail'=>'Thank you for purchasing!',
      'billChargeToCustomer'=>1
    )
    billCode = JSON.parse(http.body)
    bill_url(billCode[0]["BillCode"])
  end

  def customer_service_category
    @firstRequest = CustomerServiceRequest.new
  end

  def customer_service
    @request = CustomerServiceRequest.new
    if params[:customer_service_request][:title] == "Cash Out"
      @label = "Specify the amount you wish to cash out. You can only cash out your balance excluding fixed balance."
      cookies[:request_title] = "Cash Out"
    elsif params[:customer_service_request][:title] == "Error"
      @label = "Specify the problem you are facing."
      cookies[:request_title] = "Error"
    else
      @label = "Specify the issue you wish to report."
      cookies[:request_title] = "Report"
    end
  end

  def customer_service_request
    user = User.find_by(uuid: cookies[:user_uuid])
    csr = CustomerServiceRequest.new(request_params.to_h.merge(
      user_id: user.id,
      title: cookies[:request_title]
    ))
    csr.save
    csr.request_list.add(cookies[:request_title]) 
    csr.save
    redirect_to user_Index_path, flash: { info: "Customer Service Request has been submitted. Our Customer Service will contact you." }
  end

  def chat
    @target_user = User.find(params[:id])
    @name = User.find_by(uuid: cookies[:user_uuid]).first_name
  end

  def notification
    user = User.find(params[:id])
    UserNotification.new(user_id: params[:id]).save
  end


  private

  def request_params
    params.required(:customer_service_request).permit(:title, :description, :user_id)
  end
  def project_params
    params.required(:project).permit(:project_name, :project_description,:project_category, :project_type, :project_price, :project_deadline, :tag_list, :balance, :NDA, :project_available_deadline)
  end
  
  def check_user
    if !cookies[:user_uuid].present?
      redirect_to home_login_path
    end
  end

  def topup_status
    if cookies[:topup_status] == "1"
      if params[:status_id] == "1"
        uri = URI.parse("https://dev.toyyibpay.com/index.php/api/getBillTransactions")
        http = Net::HTTP.post_form(uri, 'billCode' => params[:billcode])
        billTransaction = JSON.parse(http.body)
        user = User.find_by(uuid: cookies[:user_uuid])
        user_credit = Credit.find_by(user_id: user.id)
        user_credit.update(balance: user_credit.balance + (billTransaction[0]["billpaymentAmount"]).to_f)
        cookies[:topup_status] = "0"
      elsif params[:status_id] == "3"
        redirect_to user_my_account_path,flash: { notice: "Failed to topup, please check your bank account balance." }
      end
    end
  end

  def chat_presence
    @user_uuid = cookies[:user_uuid]
    @publishKey = "pub-c-6c775362-cd2d-4b19-a805-6953eff53cb3"
    @subscribeKey = "sub-c-c8723627-07b7-4f78-9658-ccc6d78723db"
  end

end
