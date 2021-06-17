# frozen_string_literal: true

class Contact < ApplicationRecord
  acts_as_paranoid
  validates :name, :email, :message, presence: true


  after_create :send_mail

  def send_mail
    subject = 'Gracias por su contacto'
    template = ENV['sengrid template']
    Mailer.send_mail(self, subject, template).deliver
  end 
end
