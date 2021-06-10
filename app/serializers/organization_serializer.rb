# frozen_string_literal: true

class OrganizationSerializer < CustomActiveModelSerializer
  attributes :name, :phone, :address, :image
end
