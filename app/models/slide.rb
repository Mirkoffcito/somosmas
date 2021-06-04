class Slide < ApplicationRecord
  validate :image_url, presence: true
end
