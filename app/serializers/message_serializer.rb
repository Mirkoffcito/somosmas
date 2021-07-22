class MessageSerializer < ActiveModel::Serializer
  attributes :id, :detail, :chat, :analysis
  
  belongs_to :chat

  def analysis
    url = 'https://sentim-api.herokuapp.com/api/v1/'.freeze
    headers = { "Content-Type": "application/json" }.freeze
    SentimentalAnalysis.analysis(self, url, headers)
  end

end