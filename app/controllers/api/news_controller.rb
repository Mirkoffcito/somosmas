class Api::NewsController < ApplicationController

    before_action :authorize_request
    before_action :user_authorize, only: [:show, :destroy, :create]
    before_action :new, only: [:show, :destroy]

    def create
        @new = New.new(new_params)
        if @new.save 
            render json: @new, status: :created
        else
            render json: @new.errors, status: :bad_request
        end
    end

    def show
        render json: @new, status: :ok
    end

    def destroy
        @new.destroy
        render json: {message: 'Succesfully deleted'}
    end
    
    def new
        @new = New.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'New not found' }, status: :not_found
    end
    
    def new_params
        params.require(:new).permit(:name, :content, :category_id)
    end
end