# frozen_string_literal: true

module Api
  class ChatsController < ApplicationController
    skip_before_action :authenticate_admin

    def index
      @chats = @current_user.chats
      paginate @chats, per_page: 10, each_serializer: ChatSerializer
    end

    def create
      if chat_user.blank?
        chat = Chat.new
        chat.chat_users.build(user_id: @current_user.id)
        chat.chat_users.build(user_id: receiver)
        chat.messages.build(message_params) if message_params

        if chat.save
          render json: chat, serializer: ChatSerializer, status: :created
        elsif chat_user.nil?
          render json: { error: 'User not found' }, status: :not_found
        else
          render json: chat.errors, status: :bad_request
        end
      else
        render json: { message: "Chat already exists, chat N° #{chat_user.chat.id}" }
      end
    end

    private

    def params_attr
      params.require(:chat).permit(:receiver, message: [:detail])
    end

    def receiver
      params_attr[:receiver]
    end

    def message_params
      params_attr[:message]&.merge(user_id: @current_user.id) 
    end

    def chat_user
      @chat_user ||= ChatUser.find_by(user_id: @current_user.id,
                                      chat_id: ChatUser.where(user_id: receiver).select(:chat_id))
    end
  end
end
