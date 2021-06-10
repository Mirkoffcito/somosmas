class Api::SlidesController < ApplicationController
  before_action :authorize_request
  before_action :authenticate_admin

  def index
    @slides = Slide.all.order(:order)

    render json: @slides, each_serializer: SlidesSerializer
  end

  def destroy
    @slide = Slide.find(params[:id])

    if @slide.destroy
      render json: {message: 'Succesfully deleted'}
    else
      render json: @slide.errors
    end
  end
end
