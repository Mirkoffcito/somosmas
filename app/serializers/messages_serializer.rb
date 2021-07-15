# frozen_string_literal: true

class MessagesSerializer < ActiveModel::Serializer
  attributes :user_id, :detail, :created_at
  belongs_to :chat
end
