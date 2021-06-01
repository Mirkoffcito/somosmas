class ApplicationMailer < ActionMailer::Base
  default from: <%= ENV['DATABASE_EMAIL'] %>
  layout 'mailer'
end
