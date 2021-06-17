# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    def index
      @categories = Category.all
      render json: @categories, each_serializer: CategorySerializer
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
