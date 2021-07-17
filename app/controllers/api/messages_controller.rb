# frozen_string_literal: true

module Api
  class MessagesController < ApplicationController
    skip_before_action :authenticate_admin, only: :create

    def create
      @message = chat.messages.new(message_params)
      @message.user_id = @current_user.id
      if @message.save
        render json: @message, serializer: MessageSerializer, status: :created
      else
        render json: @message.errors, status: :bad_request
      end
    end

    private

    def chat 
      @chat ||= Chat.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:detail)
    end
    
  
  end
end