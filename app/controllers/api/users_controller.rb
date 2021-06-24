# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_admin, except: :index

    def index
      @users = User.all

      paginate @users, per_page: 5, each_serializer: UserSerializer
    end

    def show
      if @current_user
        render json: @current_user
      else
        render json: @user.errors, status: :unauthorized
      end
    end

    def destroy
      if user.id == @current_user.id
        render json: { message: 'Succesfully deleted' } if user.destroy
      else
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end

    def update
      if user.id == @current_user.id
        if user.update(user_update_params)
          render json: user
        else
          render json: user.errors
        end
      else
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end

    private
    def user
      @user ||= User.find(params[:id])
    end
    # TODO: method to validates and change user password
    def user_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :image)
    end
  end
end
