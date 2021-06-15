# frozen_string_literal: true

module Api
  class OrganizationsController < ApplicationController
    before_action :authenticate_admin, except: [:index]

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
  end
end
