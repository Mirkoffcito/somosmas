# frozen_string_literal: true

class CustomActiveModelSerializer < ActiveModel::Serializer
  # generates the url for the image attached to the user if present
  def image
    object.image.service_url if object.image.attached?
  end
end
