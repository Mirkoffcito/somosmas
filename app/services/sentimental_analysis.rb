require 'rest-client'
require 'json'

class SentimentalAnalysis

  def self.analysis(detail, url, headers)
    body = { "text": "#{detail}" }
      
    response = RestClient::Request.execute(method: :post, :url => url, :headers => headers, :payload => body.to_json)
    
    if response.code == 200
      response = JSON.parse(response) 
      response['result']
    else
      response = { "error": "Message without sentimental analysis, caused by external API failure"}
    end
  end
end
