# frozen_string_literal: true

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail, :chat, :analysis

  belongs_to :chat

  def analysis
    SentimentalAnalysis.external_api(object.detail)
  end
end
 