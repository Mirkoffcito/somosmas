# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_admin, except: :index

    def index
      @users = User.all

      paginate @users, per_page: 5, each_serializer: UserSerializer
    end

    def show
      if @current_user.role.admin? || @current_user.id == user.id
        render json: user, serializer: UserSerializer
      else
        render json: user, serializer: UserClientSerializer
      end
    end

    def destroy
      if user.id == @current_user.id
        render json: { message: 'Succesfully deleted' } if user.destroy
      else
        render json: { message: 'You do not have permission' }, status: :forbidden
      end
    end

    def update
      if user.id == @current_user.id
        if user.update(user_update_params)
          render json: user
        else
          render json: user.errors, status: :bad_request
        end
      else
        render json: { message: 'You do not have permission' }, status: :forbidden
      end
    end

    private

    def user
      if params[:id]
        @user ||= User.find(params[:id])
      else
        @user = @current_user
      end
    end

    # TODO: method to validates and change user password
    def user_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :image)
    end
  end
end
