class ActivationMailer < ApplicationMailer
  def activation(user, email_code)
    @user = user
    @email_code = email_code
    mail(to: @user.email, subject: 'Activate your Brownfield account')
  end
end
