# frozen_string_literal: true

class Testimonial < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image

  validates :name, presence: true
  validates :content, presence: true
end
