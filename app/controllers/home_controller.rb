class HomeController < ApplicationController
 
  def Index
  end

  def login
  end

  def register
    @user = User.new
  end

  def create
    reference_user = User.find_by(reference_code: params[:referral_code])
    password = params[:password]
    confirm_password = params[:confirm_password]
    user_account = User.find_by(email: params[:user][:email])
    admin_accont = Admin.find_by(email: params[:user][:email])
    role = params[:role]
    phone_number = params[:phone_number]

    if password == confirm_password
      @user = User.new(user_params.to_h.merge(password: password, phone_number: phone_number, reference_code: SecureRandom.hex(5), uuid: SecureRandom.uuid))
      if phone_number.length == 11
        if user_account.blank? && admin_accont.blank?
          @user.save
          Rating.new(user_id: @user.id).save
          credit = Credit.new(user_id: @user.id)
          credit.save
          MemberTierList.new(user_id: @user.id).save

          if !reference_user.blank?
            reference_user_credit = Credit.find_by(user_id: reference_user.id)
            reference_user_credit.update(balance: reference_user_credit.balance+20)  
            credit.update(balance: credit.balance+20)
          end
          redirect_to home_login_path, flash: { info: "Account successfully created" }
        else
          redirect_to home_register_path, notice: "Email already exist."
        end
      else
        redirect_to home_register_path, flash: { notice: "Incorrect Phone Number format, sample phone number format: 60123456798" }
      end
    else
      redirect_to home_register_path, notice: "Password does not match"
    end
  end


  def authentication
    user = User.find_by(email: params[:email])
    admin = Admin.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      cookies[:user_uuid] = user.uuid
      redirect_to user_Index_path, flash: { info: "User has logged in" }
    elsif admin.present? && admin.authenticate(params[:password])
      cookies[:admin_id] = admin.id
      redirect_to admin_index_path, flash: { info: "User has logged in" }

    else
      redirect_to home_login_path, flash: { notice: "User does not exist" }
    end
  end

  def logout
    if cookies[:user_uuid].present?
      cookies.delete :user_uuid
    elsif cookies[:admin_id].present?  
      cookies.delete :admin_id
    end
    redirect_to root_path
  end

  def edit
    @user = User.find_by(uuid: cookies[:user_uuid])

  end

  def save
    user_account = User.find_by(email: params[:user][:email])
    user = User.find_by(uuid: cookies[:user_uuid])
    phone_number = params[:phone_number]

    if phone_number.length == 11
      if user_account.blank?

        user.update(
          first_name: params[:user][:first_name], 
          last_name: params[:user][:last_name], 
          email: params[:user][:email], 
          phone_number: params[:phone_number], 
          address: params[:user][:address], 
          postcode: params[:user][:postcode], 
          country: params[:user][:country]
        )
        redirect_to user_my_account_path, flash: { info: "Account successfully updated" }
      else
        user.update(
          first_name: params[:user][:first_name], 
          last_name: params[:user][:last_name], 
          phone_number: params[:phone_number], 
          address: params[:user][:address], 
          postcode: params[:user][:postcode], 
          country: params[:user][:country]
        )
        redirect_to user_my_account_path, flash: { info: "Account successfully updated, however email already exist so email was not updated" }
      end
    else
      redirect_to home_register_path, flash: { notice: "Incorrect Phone Number format, sample phone number format: 60123456798" }
    end
  end

  def about
  end

  def privacy_policy
  end

  def password_recovery
  end

  def forgot_password
    user = User.find_by(email: params[:email])
    if user.blank?
      redirect_to home_password_recovery_path, flash: { notice: "Email does not exist." }
    else
      
      new_password = SecureRandom.base36
      user.update(password: new_password)
      HomepageMailer.with(email: params[:email], new_password: new_password).forgot_password.deliver_now
      redirect_to home_login_path, flash: { info: "Check your email for the new password." }
    end
  end

  def update_password
  end

  def update
    new_password = params[:new_password]
    confirm_new_password = params[:confirm_new_password]
    if new_password == confirm_new_password
      user = User.find_by(uuid: cookies[:user_uuid])
      if user.authenticate(params[:password])
        user.update(password: params[:new_password])
        redirect_to user_my_account_path, flash: {info: "Password has been updated."}
      else
        redirect_to home_update_password_path, notice: "Wrong password."
      end
    else
      redirect_to home_update_password_path, notice: "Password does not match."
    end
  end

  private
  
  def user_params
    params.required(:user).permit(:first_name, :last_name ,:email, :address, :postcode, :country)
  end

end
