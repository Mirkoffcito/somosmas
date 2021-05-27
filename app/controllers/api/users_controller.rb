class Api::UsersController < ApplicationController

    def register
        @user = User.create(user_params)
        if @user.save
            render json: @user, serializer: UserSerializer, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id, :image)
    end

end
