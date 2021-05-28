class Api::AuthenticationsController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid user or password" }
    end
  end

  private

    def login_params
      params.require(:user).permit(:email, :password)
    end
end
