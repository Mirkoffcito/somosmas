# frozen_string_literal: true

module Api
  class MembersController < ApplicationController
    skip_before_action :authenticate_admin, only: [:index]

    def index
      @members = Member.all
      paginate @members, per_page: 10, each_serializer: MemberSerializer

    end

    def create
      @member = Member.new(member_params)

      if @member.save
        render json: @member
      else
        render json: @member.errors, status: :bad_request
      end
    end

    def update
      byebug
      if member.update(member_params)
        render json: @member, serializer: MemberSerializer, status: :ok
      else
        render json: member.errors, status: :unprocessable_entity
      end
    end

    def destroy
      render json: { message: 'Succesfully deleted' }, status: :ok if member.destroy
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
