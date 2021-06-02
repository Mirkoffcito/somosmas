class Api::UsersController < ApplicationController
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    before_action :authorize_request, except: [:register]

    def register
        @user = User.create(user_params)
        if @user.save
            render json: @user, serializer: UserSerializer, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

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

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id, :image)
    end

    def parameter_missing
        render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
    end
end
