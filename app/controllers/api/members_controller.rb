# frozen_string_literal: true

module Api
  class MembersController < ApplicationController
    before_action :authenticate_admin, except: [:index]

    def index
      @members = Member.all
      render json: @members
    end

    def destroy
      render json: { message: 'Succesfully deleted' }, status: :ok if member.destroy
    end

    private

    def member
      @member ||= Member.find(params[:id])
    end
  end
end
