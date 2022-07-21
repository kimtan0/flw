class HomepageMailer < ApplicationMailer

  def forgot_password
    postmark_client.deliver(
      to: params[:email],
      from: 'TP050967@mail.apu.edu.my',
      subject: 'Freelancer - Forgotten Password',
      html_body: 'We have updated the password Freelancer account with the email: ' + params[:email] + '.<br/><br/>New Password: ' + params[:new_password] + '<br/><br/> If you did not send this request, please contact our customer service.'
    )
  end

  def email_user
    postmark_client.deliver(
      to: params[:email],
      from: 'TP050967@mail.apu.edu.my',
      subject: 'Freelancer - Cutomer Service Request',
      html_body: params[:content]
    )
  end


end
