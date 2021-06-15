class MemberSerializer < ActiveModel::Serializer
  attributes :id, :name, :facebook_url, :linkedin_url, :instagram_url, :description
end
