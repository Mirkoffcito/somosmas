# frozen_string_literal: true

module Api
  class AuthenticationsController < ApplicationController
    skip_before_action :authorize_request
    skip_before_action :authenticate_admin

    def register
      @user = User.new(user_params)
      if @user.save
        login
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def login
      @user = User.find_by_email(params[:user][:email])
      if @user&.authenticate(params[:user][:password])
        token = JsonWebToken.encode(user_id: @user.id)
        @user.token = token
        render json: @user, serializer: UserRegistrationSerializer, status: :ok
      else
        render json: { error: 'Invalid user or password' }, status: :bad_request
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id, :image)
    end
  end
end
