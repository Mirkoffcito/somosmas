class CustomActiveModelSerializer < ActiveModel::Serializer
    # generates the url for the image attached to the user if present
    def image
        if object.image.attached?
            object.image.blob.service_url
        end
    end
end