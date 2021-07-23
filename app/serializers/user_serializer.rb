# frozen_string_literal: true

class UserSerializer < CustomActiveModelSerializer
  attributes :id, :first_name, :last_name, :email, :role, :image, :settings

  belongs_to :role # Uses the role_serializer
end
