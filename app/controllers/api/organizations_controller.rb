class Api::OrganizationsController < ApplicationController

  def index
    @organization = Organization.first

    render json: @organization, serializer: OrganizationSerializer
  end
end
