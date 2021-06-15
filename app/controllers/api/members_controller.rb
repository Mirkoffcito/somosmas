# frozen_string_literal: true

module Api
  class MembersController < ApplicationController
<<<<<<< HEAD
    before_action :authenticate_admin, except: [:index]

    def index
      @members = Member.all
      render json: @members
    end

    def destroy
      render json: { message: 'Succesfully deleted' }, status: :ok if member.destroy
    end
=======
    before_action :authenticate_admin, only: [:create]
>>>>>>> 0cea2d9 (added only create in admin authentication callback)

    def create
      @member = Member.new(member_params)

      if @member.save
        render json: @member
      else
        render json: @member.errors, status: :bad_request
      end
    end

    private

    def member
      @member ||= Member.find(params[:id])
    end
    
    def member_params
      params.require(:member).permit(:name, :facebook_url, :linkedin_url, :instagram_url, :description)
    end

  end
end
