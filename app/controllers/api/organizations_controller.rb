# frozen_string_literal: true

module Api
  class OrganizationsController < ApplicationController
    skip_before_action :authenticate_admin, only: [:get_organization]
    skip_before_action :authorize_request, only: [:get_organization]

    def get_organization
      @organization = Organization.first
      return render json: {}, status: :ok if @organization.blank?
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
  end
end
