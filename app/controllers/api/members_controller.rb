# frozen_string_literal: true

module Api
  class MembersController < ApplicationController

    def index
      @members = Member.all
      render json: @members
    end

  end
end
