# frozen_string_literal: true

module Api
  class ActivitiesController < ApplicationController
    before_action :authorize_request
    before_action :authenticate_admin

    # POST/activities

    def create
      @activity = Activity.new(activity_params)

      if @activity.save
        render json: @activity, serializer: ActivitySerializer, status: :created
      else
        render json: @activity.errors, status: :bad_request
      end
    end

    # UPDATE/activities

    def update
      if activity.update(activity_params)
        render json: activity, serializer: ActivitySerializer, status: :ok
      else
        render json: activity.errors, status: :unprocessable_entity
      end
    end

    private

    def activity
      @activity ||= Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:name, :content, :image)
    end
  end
end
