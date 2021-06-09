class Api::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize
  before_action :category, only: [:destroy, :show]

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
      render json: { errors: 'Category not found' }, status: :not_found
  end

  def create
    @category = Category.create(category_params)

    if @category.save
      render json: @category, each_serializer: CategorySerializer
    else
      render json: @category.errors, status: :bad_request
    end
  end

  def show
    render json: @category, status: :ok
  end

  def category 
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Category not found' }, status: :not_found
  end
  
  private
    def category_params
      params.require(:category).permit(:name, :description, :image)
    end
end
