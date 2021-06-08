class ApplicationController < ActionController::API
  include AuthorizeApiRequest
  include ErrorsHelper
end
