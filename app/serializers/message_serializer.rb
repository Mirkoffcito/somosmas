class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail
  
  belongs_to :chat
  belongs_to :user, serializer: UserClientIndexSerializer

  def detail
    MessageService.user_config(object.user.settings,  object.detail)
  end
end