# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :token, :is_seed

  acts_as_paranoid
  has_one_attached :image
  has_many :contacts

  belongs_to :role, optional: true

  has_many :messages, through: :chat

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  after_create :send_mail

  private

  def send_mail
    subject = 'Bienvenidos a Somos Mas'
    template = ENV['SENDGRID_SIGNUP_TEMPLATE_ID']
    Mailer.send_mail(self, subject, template).deliver
  end
end
