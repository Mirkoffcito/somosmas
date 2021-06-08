class Api::ActivitiesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  # POST/activities

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      render json: @activity, status: :created
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :content, :image)
  end

end
