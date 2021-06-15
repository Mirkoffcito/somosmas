# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate_admin, only: :index

    def index
      @users = User.all

      render json: @users, each_serializer: UserSerializer
    end

    def show
      if @current_user
        render json: @current_user
      else
        render json: @user.errors, status: :unauthorized
      end
    end

    def destroy
      @user = User.find(params[:id])

      if @user.id == @current_user.id
        @user.destroy
        render json: { message: 'Succesfully deleted' }
      else
        render json: @user.errors, status: :unauthorized
      end
    end

    def update
      @user = User.find(params[:id])

      if @current_user.id == @user.id
        @user.update!(user_update_params)
        render json: @user
      else
        render json: @user.errors, status: :unauthorized
      end
    end

    private

    # TODO: method to validates and change user password
    def user_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :image)
    end
  end
end
