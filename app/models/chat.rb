# frozen_string_literal: true

class Chat < ApplicationRecord
  acts_as_paranoid
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages

  validates :user1, :user2, presence: true
end
