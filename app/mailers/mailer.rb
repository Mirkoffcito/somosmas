class Mailer < ApplicationMailer

  require 'sendgrid-ruby'
  include SendGrid
  def sent (email, name, subject, content)
    from = SendGrid::Email.new(email: ENV['SENDER_MAIL'], name: "Alkemy")
    to = SendGrid::Email.new(email: email, name: name)
    content = SendGrid::Content.new(type: 'text/html', value: content)
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.mail._('send').post(request_body: mail.to_json)
  end

end
