class Category < ApplicationRecord
  has_many :news

  validates :name, presence: true, uniqueness: true
  
  
end
