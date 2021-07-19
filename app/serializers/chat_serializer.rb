# frozen_string_literal: true

class ChatSerializer < CustomActiveModelSerializer
    attributes :id, :created_at
    has_many :users, each_serializer: UserClientIndexSerializer

end
  