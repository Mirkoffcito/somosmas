# frozen_string_literal: true

class Message < ApplicationRecord
  acts_as_paranoid

  belongs_to :chat
  belongs_to :user

  validates_presence_of :detail, :chat_id, :user_id

end
