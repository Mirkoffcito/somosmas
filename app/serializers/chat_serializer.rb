# frozen_string_literal: true

class ChatSerializer < ActiveModel::Serializer
    attributes :id, :created_at
    has_many :users, serializer: UserClientIndexSerializer

end
  