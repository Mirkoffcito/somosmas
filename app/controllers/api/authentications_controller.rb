class Api::AuthenticationsController < ApplicationController

  def login
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      @user.token = token
      render json: @user, serializer: UserRegistrationSerializer, status: :ok
    else
      render json: { error: "Invalid user or password" }, status: :bad_request
    end
  end

  def register
    @user = User.create(user_params)
    if @user.save
      login
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id, :image)
  end
end
