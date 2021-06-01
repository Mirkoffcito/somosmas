class Api::OrganizationsController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  before_action :set_organization, except: [:index]
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
    if user_authorize
      if @organization.update(organization_params)
        render json: @organization, serializer: OrganizationSerializer
      else
        render json: @organization.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "No eres Administrador" }, status: :unauthorized
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :image, :address, :phone)
  end

  def set_organization
    @organization = Organization.first
  end

  def parameter_missing
    render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
  end
end
