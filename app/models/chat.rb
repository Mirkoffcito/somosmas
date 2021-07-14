# frozen_string_literal: true

class Chat < ApplicationRecord
  acts_as_paranoid
  has_many :messages
  has_many :user

  validates :user1, :user2, presence: true
end
