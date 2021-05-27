class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers # Needed to display image url instead of blob

  attributes :id, :first_name, :last_name, :email, :role, :image

  belongs_to :role # Uses the role_serializer

  # generates the url for the image attached to the user if present
  def image
    rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
