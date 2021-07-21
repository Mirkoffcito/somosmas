require 'rest-client'
require 'json'

class Sentimental

  def self.analysis(detail)
    url = 'https://sentim-api.herokuapp.com/api/v1/'
    headers = { "Content-Type": "application/json" }
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
