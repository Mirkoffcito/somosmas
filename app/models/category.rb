# frozen_string_literal: true

class Category < ApplicationRecord
  has_one_attached :image
  has_many :news
  validates :name, presence: true, uniqueness: true
end
