# frozen_string_literal: true

module Api
  class CommentsController < ApplicationController
    before_action :authenticate_admin

    def index
      @comments = Comment.all
      render json: @comments
    end

  end
end
