# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    skip_before_action :authenticate_admin, only: [:index]
    skip_before_action :authorize_request, only: [:index]
    
    def index
      @categories = Category.all
      paginate @categories, per_page: 10, each_serializer: CategorySerializer
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        render json: @category, each_serializer: CategorySerializer, status: :created
      else
        render json: @category.errors, status: :bad_request
      end
    end

    def show
      render json: category, status: :ok
    end

    def update
      if category.update(category_params)
        render json: category, serializer: CategorySerializer, status: :ok
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    def destroy
      render json: { message: 'Succesfully deleted' }, status: :ok if category.destroy
    end

    private

    def category
      @category ||= Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description, :image)
    end
  end
end
