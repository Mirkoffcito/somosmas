class Api::OrganizationsController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def index
    @organization = Organization.first

    render json: @organization, serializer: OrganizationSerializer
  end

  def update
    @organization = Organization.first

    @organization.update(organization_params)
    render json: @organization, serializer: OrganizationSerializer
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :image, :address, :phone)
  end

  def parameter_missing
    render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
  end

end
