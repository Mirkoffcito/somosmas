class Api::SlidesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @slides = Slide.all.order(:order)

    render json: @slides, each_serializer: SlidesSerializer
  end

  def update
    if @slide.update(slide_params)
      render json: @slide, serializer: SlideSerializer
    else
      render json: @slide.errors, status: :unprocessable_entity
    end
  end

  private
    def slide_params
      params.require(:slide).permit(:text, :order, :image, :organization_id)
    end
end
