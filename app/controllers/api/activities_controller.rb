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

  # UPDATE/activities

  def update
    activity
    render json: @activity.errors, status: :not_found unless @activity

    if @activity.update(activity_params)
      render json: @activity
    else
      render json: @activity.errors, status: :bad_request
    end
  end

  private

  def activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :content, :image)
  end
end
