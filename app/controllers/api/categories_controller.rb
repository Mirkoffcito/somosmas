class Api::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @categories = Category.all()
    render json: @categories, each_serializer: CategorySerializer
  end

  def create
    @category = Category.create(category_params)

    if @category.save
      render json: @category, each_serializer: CategorySerializer
    else
      render json: @category.errors, status: :bad_request
    end
  end

  def update
    @category = Category.find(params[:id])
    
    if @category.update(category_params)
      render json: @category, serializer: CategorySerializer
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :description, :image)
    end
end
