class SignupMailer< ApplicationMailer

  require 'sendgrid-ruby'
  include SendGrid
    
  def signupmail
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: ENV['SENDER_MAIL'])
    mail.template_id = ENV['SENDGRID_SIGNUP_TEMPLATE_ID']
   personalization = Personalization.new
    personalization.add_to(Email.new(email: 'cfo.oostdijk@gmail.com'))
    personalization.add_dynamic_template_data({
      "subject" => "Bienvenido a Somos Mas",
      "first_name" => "Cristian})
    mail.add_personalization(personalization)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY']) 
    response = sg.client.mail._('send').post(request_body: mail.to_json) 
  end
    
end