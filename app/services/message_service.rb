class MessageService
  def self.user_config(settings, detail)
    case settings
    when 'downcase' # downcase
      detail.downcase
    when 'upcase' # upcase
      detail.upcase
    when 'accentless' # sin tildes
      I18n.transliterate(detail)
    else
      detail # sin configuracion
    end
  end
end