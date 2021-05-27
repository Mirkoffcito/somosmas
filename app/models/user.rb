class User < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image

  belongs_to :role

  has_secure_password

  # sets default value for roles
  after_initialize :set_defaults

  validates :first_name,  presence: true
  validates :last_name,  presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, on: :create
  validates :role, presence: true

  private

  # sets default role for the created user if no role is passed (allowed are  guest and admin)
  # the default set role in this case is 2, which we assume is Guest user in our db
  # which means role 1 must be admin
  def set_defaults
    if self.new_record?
      self.role_id ||= 2 # We use ||= so if we create a User with a role, it does not overwrite it
    end
  end

end
