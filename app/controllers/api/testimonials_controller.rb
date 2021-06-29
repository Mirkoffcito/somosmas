# frozen_string_literal: true

module Api
  class TestimonialsController < ApplicationController
    skip_before_action :authenticate_admin, only: :index
    skip_before_action :authorize_request, only: [:index]

    def index
      @testimonials = Testimonial.all
      paginate @testimonials, per_page: 10, each_serializer: TestimonialSerializer
    end

    def create
      @testimonial = Testimonial.new(testimonial_params)
      if @testimonial.save
        render json: @testimonial, status: :created
      else
        render json: @testimonial.errors, status: :bad_request
      end
    end

    def update
      if testimonial.update(testimonial_params)
        render json: testimonial, status: :ok
      else
        render json: testimonial.errors, status: :unprocessable_entity
      end
    end

    def destroy
      render json: { message: 'Succesfully deleted' }, status: :ok if testimonial.destroy
    end

    private

    def testimonial
      @testimonial ||= Testimonial.find(params[:id])
    end

    def testimonial_params
      params.require(:testimonial).permit(:name, :content)
    end
  end
end
