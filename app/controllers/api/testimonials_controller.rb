# frozen_string_literal: true

module Api
  class TestimonialsController < ApplicationController
    before_action :authenticate_admin
    before_action :testimonial, only: %i[destroy]

    def destroy
      render json: { message: 'Succesfully deleted' }, status: :ok if testimonial.destroy
    end

    private

    def testimonial
      @testimonial ||= Testimonial.find(params[:id])
    end
  end
end
