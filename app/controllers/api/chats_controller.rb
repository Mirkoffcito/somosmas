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
        chat.chat_users.build(user_id: params[:receiver])
      else
        chat = chat_user.chat
      end

      if chat.save
        render json: chat, serializer: ChatSerializer, status: :created
      else
        render json: chat.errors, status: :bad_request
      end
    end

    private

    def chat_user
      ChatUser.find_by(user_id: @current_user.id, chat_id: ChatUser.where(user_id: params[:receiver]).select(:chat_id))
    end
  end
end
