class MessageSerializer < ActiveModel::Serializer
  
  attributes :id, :detail, :chat, :analysis
  
  belongs_to :chat

  def analysis
    url = 'https://sentim-api.herokuapp.com/api/v1/'.freeze
    headers = { "Content-Type": "application/json" }.freeze
    body = { "text": "#{self}" }
    response = RestClient::Request.execute(method: :post, :url => url, :headers => headers, :payload => body.to_json)
    SentimentalAnalysis.analysis(response)
  end

end