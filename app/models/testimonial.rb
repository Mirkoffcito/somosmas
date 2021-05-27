class Testimonial < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image
  
  validates :name, :content, presence: true
end
