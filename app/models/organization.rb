class Organization < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image
  has_many :slides

  validates :name, :email, :welcome_text, presence: true
end
