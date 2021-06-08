class Category < ApplicationRecord

  has_one_attached :image
  has_many :news
  validates :name, presence: true, uniqueness: true, 
            format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  
end
