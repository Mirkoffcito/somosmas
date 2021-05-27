json.array! @organization do |data|
  json.name data.name
  json.image rails_blob_url(data.image) if data.image.attached?
  json.phone data.phone
  json.address data.address
end
