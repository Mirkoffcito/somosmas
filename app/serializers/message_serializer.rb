class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail
  
  belongs_to :chat
  belongs_to :user, serializer: UserClientIndexSerializer

  def detail
    case object.user.settings
    when 'downcase' # downcase
      object.detail.downcase
    when 'upcase' # upcase
      object.detail.upcase
    when 'accentless' # sin tildes
      I18n.transliterate(object.detail)
    else
      object.detail # sin configuracion
    end
  end
end