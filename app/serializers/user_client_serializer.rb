class UserClientSerializer < CustomActiveModelSerializer
  attributes :id, :first_name, :last_name, :email, :image
end
