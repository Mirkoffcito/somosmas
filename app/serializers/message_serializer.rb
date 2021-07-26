# frozen_string_literal: true

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail, :chat, :analysis

  belongs_to :chat
  belongs_to :user, serializer: UserClientIndexSerializer

  def analysis
    SentimentalAnalysis.external_api(object.detail)
  end

  def detail
    MessageService.user_config(object.user.settings,  object.detail)
  end
end
