class Slide < ApplicationRecord
  validates :image_url, presence: true
end
