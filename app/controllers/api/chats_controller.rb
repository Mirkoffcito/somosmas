# frozen_string_literal: true

module Api
  class ChatsController < ApplicationController
    skip_before_action :authenticate_admin

    def create
      chat = find_chat

      if chat.blank?
        chat = Chat.new(chat_params)
        chat.user1 = @current_user.id
      else
        chat.messages.build(message_params)
      end

      if chat.save
        render json: chat, serializer: ChatSerializer, status: :created
      else
        render json: chat.errors, status: :bad_request
      end
    end

    private

    def permitted_params
      params.require(:chat).permit(:user2, message: [:detail])
    end

    def message_params
      permitted_params[:message].merge(user_id: @current_user.id)
    end

    def chat_params
      permitted_params.slice(:user2)
                      .merge(messages_attributes: [message_params])
    end

    def find_chat
      Chat.where(user1: @current_user.id,
                 user2: params[:chat][:user2]).or(Chat.where(user1: params[:chat][:user2],
                                                             user2: @current_user.id)).first
    end
  end
end
