class Api::OrganizationsController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @organization = Organization.first
    
    if user_authorize
      render json: @organization, serializer: OrganizationSerializer
    else
      render json: { error: "No eres Administrador" }, status: :unauthorized
    end
  end
end
