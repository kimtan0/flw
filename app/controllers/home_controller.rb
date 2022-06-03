class HomeController < ApplicationController
 
  def Index
  end

  def login
  end

  def register
    @user = User.new
    
  end

  def create
    password = params[:password]
    confirm_password = params[:confirm_password]
    user_account = User.find_by(email: params[:user][:email])
    role = params[:role]
    phone_number = params[:phone_number]

    if password == confirm_password
      @user = User.new(user_params.to_h.merge(password: password))
      
      if phone_number.length == 11
        if user_account.blank?
          @user.save
          if role == "freelancer"
            @user.update_attribute(:freelancer_status, true)
          else
            @user.update_attribute(:employer_status, true)
          end
          redirect_to login_path, flash: { info: "Account successfully created" }
        else
          redirect_to register_path, notice: "Email already exist."
        end
      else
        redirect_to register_path, flash: { notice: "Incorrect Phone Number format, sample phone number format: 60123456798" }
      end
    else
      redirect_to register_path, notice: "Password does not match"
    end
  end


  def authentication
    user = User.find_by(email: params[:email])

    if user.present? && user.authenticate(params[:password])
      cookies[:user_id] = user.id
      if user.employer_status == true && user.freelancer_status == true
        cookies[:user_role] = "both"
      elsif user.employer_status == true
        cookies[:user_role] = "employer"
      else
        cookies[:user_role] = "freelancer"
      end
      redirect_to user_Index_path, flash: { info: "User has logged in" }
    else
      redirect_to login_path, flash: { notice: "User does not exist" }
    end
  end


  private
  
  def user_params
    params.required(:user).permit(:first_name, :last_name ,:email, :address, :postcode, :country)
  end

end
