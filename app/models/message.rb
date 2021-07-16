# frozen_string_literal: true

class Message < ApplicationRecord
  acts_as_paranoid

  belongs_to :chat
  belongs_to :user
  validates :user_id, :detail, presence: true
end
