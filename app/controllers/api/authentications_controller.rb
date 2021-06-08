class Api::AuthenticationsController < ApplicationController
  rescue_from StandardError, with: :parameter_missing

  def login
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token }, status: :ok
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
    
    def parameter_missing
      render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
    end
    
end
