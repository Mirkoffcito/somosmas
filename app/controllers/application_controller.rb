# frozen_string_literal: true

class ApplicationController < ActionController::API
  include AuthorizeApiRequest
  include ErrorsHelper
  include Permissions

  before_action :authorize_request
end
