class Api::NewsController < ApplicationController
    before_action :authorize_request
    before_action :authenticate_admin, only: [:create, :destroy, :show]
    before_action :new, only: [:show, :destroy]

    def show
        render json: @new, status: :ok
    end

    def create
        @new = New.new(new_params)
        if @new.save 
            render json: @new, status: :created
        else
            render json: @new.errors, status: :bad_request
        end
    end

    def destroy
        if @new.destroy
            render json: {message: 'Succesfully deleted'}, status: :ok
        end
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