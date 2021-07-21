class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail, :chat, :analysis
  
  belongs_to :chat
end