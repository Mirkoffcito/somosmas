class ApplicationController < ActionController::API
  
  def authorize_request
    AuthorizeApiRequest::authorize_request
  end
  
end
