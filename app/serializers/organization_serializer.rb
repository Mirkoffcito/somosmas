# frozen_string_literal: true

class OrganizationSerializer < CustomActiveModelSerializer
  attributes :name, :phone, :address, :image
  has_many :slides, serializer: SlidesSerializer do
    object.slides.order(:order)
  end
end
