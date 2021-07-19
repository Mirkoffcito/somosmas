class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail, :chat
  
  belongs_to :chat
end