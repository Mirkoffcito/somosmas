# frozen_string_literal: true

class New < ApplicationRecord
  acts_as_paranoid
  has_one_attached :image
  belongs_to :category
  validates :name, :content, presence: true
  has_many :comments
end
