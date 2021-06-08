class New < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image
  belongs_to :category
  validates :name, presence: true
  validates :content, presence: true
  
end
