class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  protected
  def postmark_client
    Postmark::ApiClient.new('ccef261e-4d41-4c97-96fe-2c7b27bf2321')
  end
end
