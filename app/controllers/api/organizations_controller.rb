class Api::OrganizationsController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def index
    @organization = Organization.first
    
    if user_authorize
      render json: @organization, serializer: OrganizationSerializer
    else
      render json: { error: "No eres Administrador" }, status: :unauthorized
    end
  end

  def update
    unless user_authorize # if user is not an admin
      render json: { error: "No eres Administrador" }, status: :unauthorized
    else # if user is an admin
      if organization
        @organization.update(organization_params)
        render json: @organization, serializer: OrganizationSerializer
      else
        render json: @organization.errors, status: :unprocessable_entity
      end
    end
  end

  def organization
    @organization = Organization.first
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :image, :address, :phone)
  end

  def parameter_missing
    render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
  end
end
