class Api::NewsController < ApplicationController
    before_action :authorize_request
    before_action :user_authorize, only: [:show, :destroy]
    before_action :new, only: [:show, :destroy]

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
end