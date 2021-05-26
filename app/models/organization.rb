class Organization < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image
  
  validates :name, :email, :welcome_text, presence: true

end
