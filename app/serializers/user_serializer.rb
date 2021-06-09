class UserSerializer < CustomActiveModelSerializer
  attributes :id, :first_name, :last_name, :email, :role, :image, :token

  belongs_to :role # Uses the role_serializer

end
