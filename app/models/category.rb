class Category < ApplicationRecord
  acts_as_paranoid
  
  has_one_attached :image
  has_many :news

  validates :name, presence: true, uniqueness: true 

end
