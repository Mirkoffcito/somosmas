class UserMailer < ApplicationMailer

  def send_signup_email(user)
    @user = user
    mail( :to => @user.email, :subject => 'Bienvenido a Somos Mas' )
  end

end