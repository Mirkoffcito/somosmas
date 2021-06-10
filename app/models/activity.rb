# frozen_string_literal: true

class Activity < ApplicationRecord
  validates :name, presence: true
  validates :content, presence: true
  has_one_attached :image
end
