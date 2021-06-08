class Api::NewsController < ApplicationController

    before_action :authorize_request
    before_action :user_authorize, only: [:create]

    def create
        @new = New.new(new_params)
        if @new.save 
            render json: @new, status: :created
        else
            render json: @new.errors, status: :bad_request
        end
    end

    
    def new_params
        params.require(:new).permit(:name, :content, :category_id)
    end
end