# frozen_string_literal: true

class ChatSerializer < ActiveModel::Serializer
  attributes :id, :user1, :user2
  has_many :messages, serializer: MessagesSerializer do
    object.messages.order(created_at: :desc)
  end
end
