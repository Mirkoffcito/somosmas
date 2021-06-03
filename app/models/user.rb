class User < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image

  belongs_to :role, optional: true

  has_secure_password

  validates :first_name,  presence: true
  validates :last_name,  presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, on: :create

  def is_admin?
    role_id == 1
  end

  after_create :signup_mail
  def signup_mail
    SignupMailer.signup_mail(self).deliver
  end

end
