# frozen_string_literal: true

class Slide < ApplicationRecord
  has_one_attached :image
  belongs_to :organization
end
