class Api::SlidesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  before_action :authenticate_admin

  def index
    @slides = Slide.all.order(:order)

    render json: @slides, each_serializer: SlidesSerializer
  end

<<<<<<< HEAD
  def create   
    @slide = Slide.new(slide_params)
    @slide.order = @slides.last.order + 1 if @slide.order.nil?
    if @slide.save
      render json: @slide serializer SlidesSerializer
    else
      render json: @slide.errors, status: :unprocessable_entity
    end
  end

  def update
    if slide.update(slide_params)
      render json: slide, serializer: SlideSerializer
=======
  def show
    if slide
      render json: @slide, serializer: SlideShowSerializer
>>>>>>> bec6327 (fixed controller and changed slides serializer's name)
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
    render json: @slide, serializer: SlideSerializer if slide
  end

  private
    def slide_params
      params.require(:slide).permit(:text, :order, :image, :organization_id)
    end

    def slide
      @slide ||= Slide.find(params[:id])
    end
end
