# frozen_string_literal: true

class Contact < ApplicationRecord
  acts_as_paranoid
  validates :name, :email, :message, presence: true
  belongs_to :user

  after_create :send_mail

  def send_mail
   
    subject = 'Gracias por su contacto'
    template = ENV['SENDGRID_CONTACT_EMAIL_TEMPLATE_ID']
    Mailer.send_mail(self, subject, template).deliver
  end 
 
  
end

