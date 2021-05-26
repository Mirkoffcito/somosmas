class Category < ApplicationRecord
  has_many :news
  has_one_attached :photo
  validates :name, presence: true, uniqueness: true
   
end
