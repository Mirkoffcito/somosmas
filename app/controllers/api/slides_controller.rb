class Api::SlidesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  before_action :authenticate_admin

  def index
    @slides = Slide.all.order(:order)

    render json: @slides, each_serializer: SlidesSerializer
  end

  def create   
    @slide = Slide.new(slide_params)
    @slide.order = @slides.last.order + 1 if @slide.order.nil?
    if @slide.save
      render json: @slide serializer SlidesSerializer
    else
      render json: @slide.errors, status: :unprocessable_entity
    end
  end

  def slide_params
    require(:slide).permit(:image, :order, :text, :organization_id)
  end
end
