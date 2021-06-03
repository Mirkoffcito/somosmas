class SignupMailer< ApplicationMailer

  require 'sendgrid-ruby'
  include SendGrid
    
  def signup_mail (user)
    @user = user
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: ENV['SENDER_MAIL'])
    mail.template_id = ENV['SENDGRID_SIGNUP_TEMPLATE_ID']
    personalization = Personalization.new
    personalization.add_to(Email.new(email: @user.email))
    personalization.add_dynamic_template_data({
    "subject" => "Bienvenido a Somos Mas",
    "first_name" => @user.first_name})
    mail.add_personalization(personalization)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY']) 
    response = sg.client.mail._('send').post(request_body: mail.to_json) 
  end
    
end