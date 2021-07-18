# frozen_string_literal: true

module Api
  class MessagesController < ApplicationController
    skip_before_action :authenticate_admin, only: [:show, :create, :update]

    def show
      render json: message, serializer: MessageSerializer, status: :ok
    end

    def create
      @message = chat.messages.new(message_params)
      @message.user_id = @current_user.id
      if @message.save
        render json: @message, serializer: MessageSerializer, status: :created
      else
        render json: @message.errors, status: :bad_request
      end
    end

    def update
      @message = @current_user.messages.where(chat_id: params[:id]).last
      if message.update(message_update_params)
        @message.update(modified: true)
        render json: message, serializer: MessageSerializer, status: :ok
      end
    end

    private

    def message
      @message ||= @current_user.messages.find(params[:id])
    end

    def chat 
      @chat ||= Chat.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:detail)
    end

    def message_update_params
      params.require(:message).permit(:detail)
    end
  end
end