class User < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image

  belongs_to :role

  has_secure_password
end
