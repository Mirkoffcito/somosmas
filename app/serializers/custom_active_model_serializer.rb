class CustomActiveModelSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers # Needed to display image url instead of blob

    # generates the url for the image attached to the user if present
    def image
        rails_blob_url(object.image, only_path: false) if object.image.attached?
    end
end