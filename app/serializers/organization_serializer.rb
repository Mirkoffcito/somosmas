# frozen_string_literal: true

class OrganizationSerializer < CustomActiveModelSerializer
  attributes :name, :address, :phone, :email, :welcome_text, :about_us_text,  :image, :facebook_url, :instagram_url, :linkedin_url
  has_many :slides, serializer: SlidesSerializer do
    object.slides.order(:order)
  end
end
