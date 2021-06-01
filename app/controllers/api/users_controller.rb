class Api::UsersController < ApplicationController
    rescue_from ActionController::ParameterMissing, with: :parameter_missing

    def register
        @user = User.create(user_params)
        if @user.save
            render json: @user, serializer: UserSerializer, status: :created
            UserMailer.send_signup_email(@user).deliver
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
