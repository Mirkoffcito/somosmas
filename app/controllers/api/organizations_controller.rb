class Api::OrganizationsController < ApplicationController

  def index
    @organization = Organization.all
  end
end
