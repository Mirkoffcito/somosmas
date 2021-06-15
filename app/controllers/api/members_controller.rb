# frozen_string_literal: true

module Api
  class MembersController < ApplicationController
    skip_before_action :authorize_request

    def index
      @members = Member.all
      render json: @members
    end

  end
end
