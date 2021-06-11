class Api::SlidesController < ApplicationController
  before_action :authorize_request
  before_action :authenticate_admin

  def index
    @slides = Slide.all.order(:order)

    render json: @slides, each_serializer: SlidesSerializer
  end

  def create   
    @slide = Slide.new(slide_params)
    @slide.order = Slide.order(:order).last.try(:order).to_i+1 if @slide.order.nil?

    if @slide.save
      render json: @slide, serializer: SlideSerializer
    else
      render json: @slide.errors, status: :unprocessable_entity
    end
  end

  def update
    if slide.update(slide_params)
      render json: slide, serializer: SlideSerializer
    else
      render json: slide.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if slide.destroy
      render json: {message: 'Succesfully deleted'}
    else
      render json: slide.errors
    end
  end

  # Not found error gets treated in app/controllers/concerns/errors_helper.rb
  # GET /slides/:id
  def show
    render json: slide, serializer: SlideSerializer if slide
  end

  private
    def slide_params
      params.require(:slide).permit(:text, :order, :image, :organization_id)
    end

    def slide
      @slide ||= Slide.find(params[:id])
    end
end
