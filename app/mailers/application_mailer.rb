class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  helper :application, :meta_tags
end
