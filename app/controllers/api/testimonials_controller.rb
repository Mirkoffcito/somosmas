# frozen_string_literal: true

module Api
  class TestimonialsController < ApplicationController
    before_action :authenticate_admin, only: [:update]

    def update
      if testimonial.update(testimonial_params)
        render json: testimonial, status: :ok
      else
        render json: testimonial.errors, status: :unprocessable_entity
      end
    end

    def testimonial
      @testimonial ||= Testimonial.find(params[:id])
    end

    def testimonial_params
      params.require(:testimonial).permit(:name, :content)
    end
  end
end
