require 'rest-client'
require 'json'

class SentimentalAnalysis

  def self.analysis(response)
    if response.code == 200
      response = JSON.parse(response) 
      response['result']
    else
      response = { "error": "Message without sentimental analysis, caused by external API failure"}
    end
  end
end
