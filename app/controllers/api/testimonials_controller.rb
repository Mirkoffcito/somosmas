
class Api::TestimonialsController < ApplicationController
  before_action :authenticate_admin, only: %i[create]

  def create
    @testimonial = Testimonial.new(testimonial_params)
    if @testimonial.save
      render json: @testimonial, status: :created
    else
      render json: @testimonial.errors, status: :bad_request
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:name, :content)
  end
end
