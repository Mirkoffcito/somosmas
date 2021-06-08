class Api::SlidesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @slides = Slide.all.order(:order)

    render json: @slides, each_serializer: SlidesSerializer
  end
end
