class ApplicationMailer < ActionMailer::Base
  # default from: 'from@example.com'
  default from: ENV["FROM_MY_GMAIL"]
  layout 'mailer'
end
