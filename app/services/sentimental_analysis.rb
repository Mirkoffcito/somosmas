# frozen_string_literal: true

require 'rest-client'
require 'json'

class SentimentalAnalysis

  URL = 'https://sentim-api.herokuapp.com/api/v1/'.freeze
  HEADERS = { "Content-Type": "application/json" }.freeze

  def self.external_api(detail)
    body = { "text": "#{detail}" }    
    response = RestClient::Request.execute(method: :post, :url => URL, :headers => HEADERS, :payload => body.to_json)
  end

  def build_response
    byebug
    if response.code == 200
      response = JSON.parse(response)
      response['result']
    else
      response = { "error": 'Message without sentimental analysis, caused by external API failure' }
    end
  end
end
