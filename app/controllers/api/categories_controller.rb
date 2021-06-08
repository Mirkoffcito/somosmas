class Api::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @categories = Category.all()
    render json: @categories, each_serializer: CategorySerializer
  end

  def destroy
    @category = Category.find(params[:id])
    render json: @category.errors, status: :not_found unless @category

    if @category.destroy
      render json: {message: 'Succesfully deleted'}
    else
      render json: @category.errors, status: :unauthorized
    end
  end

end
