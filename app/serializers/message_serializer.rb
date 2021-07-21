class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail
  
  belongs_to :chat
  belongs_to :user, serializer: UserClientIndexSerializer

  def detail
    case object.user.settings
    when 'downcase' # Uppercase
      object.detail.downcase
    when 'upcase' # lowercase
      object.detail.upcase
    when 'accentless'
      I18n.transliterate(object.detail)
    else
      object.detail
    end
  end
end