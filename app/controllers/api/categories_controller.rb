class Api::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @categories = Category.all()
    render json: @categories, each_serializer: CategorySerializer
  end

  def destroy
    if @category.destroy
      render json: {message: 'Succesfully deleted'}, status: :ok
    end
  end

  def category
    @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'New not found' }, status: :not_found
  end

end
