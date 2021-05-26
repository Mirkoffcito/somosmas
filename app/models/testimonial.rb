class Testimonial < ApplicationRecord
  acts_as_paranoid

  has_one_attached :image, presence: true
  
  validates :name, :content, presence: true

end
