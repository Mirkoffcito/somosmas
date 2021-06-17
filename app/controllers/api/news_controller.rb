# frozen_string_literal: true

module Api
  class NewsController < ApplicationController
    def create
      @new = New.new(new_params)
      if @new.save
        render json: @new, status: :created
      else
        render json: @new.errors, status: :bad_request
      end
    end

    def show
      render json: article, status: :ok
    end

    def update
      if article.update(new_params)
        render json: article, status: :ok
      else
        render json: article.errors, status: :unprocessable_entity
      end
    end

    def destroy
      render json: { message: 'Successfully deleted' }, status: :ok if article.destroy
    end

    private

    def article
      @new ||= New.find(params[:id])
    end

    def new_params
      params.require(:new).permit(:name, :content, :category_id)
    end
  end
end
