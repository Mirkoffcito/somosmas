# frozen_string_literal: true

class ChatSerializer < CustomActiveModelSerializer
    attributes :user, :create_at
end
  