# This module helps so instead of using 'JSON.parse' to parse a json response into a variable
# we already have our variable 'json_response' with the parsed JSON

module Request
    module JsonHelpers
      def json_response
        @json_response ||= JSON.parse(response.body, symbolize_names: true)
      end
    end
end