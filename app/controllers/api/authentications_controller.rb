class Api::AuthenticationsController < ApplicationController
  rescue_from StandardError, with: :parameter_missing
  before_action :authorize_request, except: :login

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

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end
    
    def parameter_missing
      render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
    end
end
