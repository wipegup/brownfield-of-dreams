class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@brownfield-mlwp.herokuapp.com'
  layout 'mailer'
end
