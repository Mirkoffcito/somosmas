class OrganizationSerializer < CustomActiveModelSerializer
  attributes :name, :phone, :address, :image
end
