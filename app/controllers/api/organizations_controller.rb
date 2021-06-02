class Api::OrganizationsController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

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
        @organization = Organization.first

        @organization.update!(organization_params)
        render json: @organization, serializer: OrganizationSerializer
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :image, :address, :phone)
  end

  def parameter_missing
    render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
  end

  def record_invalid
    render json: {error: 'Invalid phone number'}, status: :unprocessable_entity
  end
end
