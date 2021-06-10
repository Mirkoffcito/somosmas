# frozen_string_literal: true

class Member < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  has_one_attached :image
end
