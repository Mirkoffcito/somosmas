# frozen_string_literal: true

class Activity < ApplicationRecord
  validates :name, :content, presence: true
  has_one_attached :image
end
